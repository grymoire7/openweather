require 'rails_helper'

GeocoderResult = Struct.new(:data)

RSpec.describe GeocodingService do
  describe ".call" do
    let(:geocoder_result) do
      GeocoderResult.new(
        {
          "properties" => {
            "lat" => 37.33182,
            "lon" => -122.03118,
            "city" => "Cupertino",
            "state" => "California",
            "country_code" => "us",
            "postcode" => "95014"
          }
        }
      )
    end

    before do
      allow(Geocoder).to receive(:search).and_return([ geocoder_result ])
    end

    it "returns a hash with geocoding data" do
      address = "1 Infinite Loop, Cupertino, CA 95014"
      geocoding_data = GeocodingService.call(address)
      expect(geocoding_data).to include(
        "city" => "Cupertino",
        "state" => "California",
        "name" => "Cupertino, California",
        "country_code" => "us",
        "postal_code" => "95014"
      )
      expect(geocoding_data[:latitude]).to be_within(0.01).of(37.33)
      expect(geocoding_data[:longitude]).to be_within(0.01).of(-122.03)
    end

    it "raises GeocodingError for an invalid address" do
      address = "Invalid Address"
      allow(Geocoder).to receive(:search).and_return([])
      expect { GeocodingService.call(address) }.to raise_error(GeocodingError, "Address not found")
    end

    it "handles missing city in geocoding data" do
      geocoder_result.data["properties"].delete("city")
      address = "1 Infinite Loop, Cupertino, CA 95014"
      expect { GeocodingService.call(address) }.to raise_error(GeocodingError, "Geocoder city is missing")
    end

    it "handles missing state in geocoding data" do
      geocoder_result.data["properties"].delete("state")
      address = "1 Infinite Loop, Cupertino, CA 95014"
      expect { GeocodingService.call(address) }.to raise_error(GeocodingError, "Geocoder state is missing")
    end
  end
end
