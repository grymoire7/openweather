require 'rails_helper'

RSpec.describe WeatherService do
  describe ".call" do
    ADDRESS = "1 Infinite Loop, Cupertino, CA 95014"
    let(:address) { ADDRESS }

    before do
      allow(GeocodingService).to receive(:call).and_return(
        {
          latitude: 37.33182,
          longitude: -122.03118,
          name: "Cupertino",
          results_cached: true
        }
      )

      allow(WeatherService).to receive(:fetch_weather_data).and_return(
        {
          daily: [{
            temp: {
              max: 75.0,
              min: 65.0
            }
          }],
          current: {
            humidity: 50,
            temp: 72.5,
            weather: [{
              main: "Clear",
              description: "clear sky"
            }]
          }
        }
      )
    end

    it "returns a hash with weather data" do
      weather_data = WeatherService.call(address: address)
      expect(weather_data).to include(
        icon_url:          be_a(String),
        status:            be_a(String),
        description:       be_a(String),
        temperature:       be_a(Float),
        high:              be_a(Float),
        low:               be_a(Float),
        humidity:          be_a(Integer),
        name:              be_a(String),
        latitude:          be_a(Float),
        longitude:         be_a(Float),
        weather_cached:    be_in([ true, false ]),
        geocoding_cached:  be_in([ true, false ])
      )
    end
  end
end
