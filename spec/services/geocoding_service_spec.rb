require 'rails_helper'

GeocoderResult = Struct.new(:data)

RSpec.describe GeocodingService do
  describe ".call" do
    before do
      geocoder_result = GeocoderResult.new(
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

      allow(Geocoder).to receive(:search).and_return([ geocoder_result ])
    end

    it "returns a hash with geocoding data" do
      address = "1 Infinite Loop, Cupertino, CA 95014"
      geocoding_data = GeocodingService.call(address)
      expect(geocoding_data).to include(
        city: "Cupertino",
        state: "California",
        name: "Cupertino, California",
        country_code: "us",
        postal_code: "95014"
      )
      expect(geocoding_data[:latitude]).to be_within(0.01).of(37.33)
      expect(geocoding_data[:longitude]).to be_within(0.01).of(-122.03)
    end
  end
end
