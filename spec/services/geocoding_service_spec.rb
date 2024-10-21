require 'rails_helper'

RSpec.describe GeocodingService do
  describe ".call" do
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

    it "raises an error if the address is invalid" do
      address = ""
      expect { GeocodingService.call(address) }.to raise_error(IOError)
    end
  end
end
