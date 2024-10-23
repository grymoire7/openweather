require 'rails_helper'

RSpec.describe WeatherService do
  describe ".call" do
    let(:address) { "1 Infinite Loop, Cupertino, CA 95014" }
    let(:weather_data) { WeatherService.call(address: address) }

    it "returns a hash with weather data" do
      expect(weather_data).to include(
        icon_url: be_a(String),
        status:            be_a(String),
        description:       be_a(String),
        temperature:       be_a(Float),
        high:              be_a(Float),
        low:               be_a(Float),
        feels_like:        be_a(Float),
        humidity:          be_a(Integer),
        name:              be_a(String),
        latitude:          be_a(Float),
        longitude:         be_a(Float),
        weather_cached:    be_in([ true, false ]),
        geocoding_cached:  be_in([ true, false ])
      )
    end

    it "raises an error if the address is invalid" do
      expect { WeatherService.call(address: "") }.to raise_error(IOError)
    end
  end
end
