require 'rails_helper'

RSpec.describe WeatherService do
  describe ".call" do
    let(:address) { "1 Infinite Loop, Cupertino, CA 95014" }
    let(:weather_data) { WeatherService.call(address: address) }

    it "returns a hash with weather data" do
      expect(weather_data).to include(
        geo: be_a(Hash),
        daily: be_an(Array).and(
          have_attributes(
            first: include(
              temp: include(
                max: be_a(Float),
                min: be_a(Float)
              )
            )
          )
        ),
        current: include(
          temp: be_a(Float),
          feels_like: be_a(Float),
          weather: include(a_hash_including(
            main: be_a(String),
            description: be_a(String),
            icon: be_a(String)
          ))
        ),
        lat: be_a(Float),
        lon: be_a(Float),
        results_cached: be_in([ true, false ])
      )
    end

    it "raises an error if the address is invalid" do
      expect { WeatherService.call(address: "") }.to raise_error(IOError)
    end
  end
end
