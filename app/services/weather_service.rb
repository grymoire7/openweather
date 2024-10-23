# This service fetches weather data for a given address.
# The service uses the GeocodingService to get the latitude and longitude for the address.
# The service then uses the OpenWeatherMap.org API to get the weather data for the latitude and longitude.
# The service caches the weather data for 30 minutes.
#
# @see GeocodingService

class WeatherService
  OWM_API_KEY=Rails.application.credentials.dig(:development, :openweathermap, :api_key)
  WEATHER_BASE_URL = "https://api.openweathermap.org/data/3.0/onecall"
  CURRENT_ICON_BASE_URL = "http://openweathermap.org/img/wn"
  TEMP_UNITS = "imperial"

  # Fetches weather data for a given address.
  #
  # @param address [String] the target address for weather data
  # @return [Hash] the weather data for the address
  #
  # @see GeocodingService
  def self.call(address:)
    geocoding_data = GeocodingService.call(address)
    zip = geocoding_data[:postal_code]

    results_cached = true
    results = Rails.cache.fetch("weather/zip/#{zip}", exprires_in: 30.minutes, skip_nil: true) do
      results_cached = false
      weather_data = fetch_weather_data(geocoding_data[:longitude], geocoding_data[:latitude])
      selected_results(weather_data, geocoding_data)
    end
    results.merge({ results_cached: results_cached }).with_indifferent_access
  end

  private

  # Combines selected weather and geocoding data into a single hash.
  #
  # @params: weather_data [Hash] the weather data from the OpenWeatherMap API
  # @params: geocoding_data [Hash] the geocoding data from the GeocodingService
  # @returns: [Hash] selected data from the weather and geocoding data
  def self.selected_results(weather_data, geocoding_data)
    current_weather = weather_data[:current][:weather].first
    icon_base = current_weather[:icon]

    {
      icon_url:          "#{CURRENT_ICON_BASE_URL}/#{icon_base}@2x.png",
      status:            current_weather[:main],
      description:       current_weather[:description],
      temperature:       weather_data.dig(:current, :temp),
      high:              weather_data[:daily].first[:temp][:max],
      low:               weather_data[:daily].first[:temp][:min],
      feels_like:        weather_data.dig(:current, :feels_like),
      humidity:          weather_data.dig(:current, :humidity),
      name:              geocoding_data[:name],
      latitude:          geocoding_data[:latitude],
      longitude:         geocoding_data[:longitude],
      weather_cached:    weather_data[:results_cached],
      geocoding_cached:  geocoding_data[:results_cached]
    }
  end

  # Fetches weather data from the OpenWeatherMap API.
  #
  # @params: lon [Float] the longitude of the target location
  # @params: lat [Float] the latitude of the target location
  # @returns: [Hash] the weather data from the OpenWeatherMap API
  def self.fetch_weather_data(lon, lat)
    exclude = "minutely,hourly"

    request = Typhoeus::Request.new(
      WEATHER_BASE_URL,
      method: :get,
      params: { lat: lat, lon: lon, units: TEMP_UNITS, exclude: exclude, appid: OWM_API_KEY }
    )
    response = request.run
    raise IOError.new("Weather service error: #{response.return_message}") if response.code != 200

    JSON.parse(response.body, symbolize_names: true).with_indifferent_access
  end
end
