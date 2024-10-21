# The OpenWeatherMap.org weather service
# provides weather data for a given zip code.

class WeatherService
  OWM_API_KEY=Rails.application.credentials.dig(Rails.env.to_sym, :openweathermap, :api_key)
  WEATHER_BASE_URL = "https://api.openweathermap.org/data/3.0/onecall"

  # @param zip_code [String] the target zip code for weather data
  # @param units [String] one of "imperial", "standard", or "metric"
  def initialize(address:, units: "imperial")
    @address = address
    @units = units
  end

  def call
    weather
  end

  private

  attr_reader :units, :zip_code, :geocoding, :address

  def weather
    # {"latitude"=>{float}, "longitude"=>{float}, "country_code"=>{string}, "postal_code"=>{string}}
    @geocoding = GeocodingService.call(@address)
    puts "geocoding: #{@geocoding}"
    zip = geocoding[:postal_code]

    results_cached = true
    results = Rails.cache.fetch("weather/zip/#{zip}", exprires_in: 30.minutes, skip_nil: true) do
      results_cached = false
      combined_results
    end
    results.merge({ results_cached: results_cached })
  end

  def combined_results
    response = weather_data_response
    raise IOError.new("Weather service error: #{response.return_message}") if response.code != 200

    weather_data = JSON.parse(response.body)
    weather_data[:geo] = geocoding
    puts "weather_data: #{weather_data}"

    weather_data
  end

  def weather_data_response
    lon = geocoding[:longitude]
    lat = geocoding[:latitude]
    puts "geocoding: #{geocoding}"
    exclude = "minutely,hourly"

    # https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}
    request = Typhoeus::Request.new(
      WEATHER_BASE_URL,
      method: :get,
      params: { lat: lat, lon: lon, units: units, exclude: exclude, appid: OWM_API_KEY }
    )
    request.run
  end
end
