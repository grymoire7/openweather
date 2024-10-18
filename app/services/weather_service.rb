# OpenWeatherMap.org weather service
# Provides weather data for a given zip code.

class WeatherService
  OWM_API_KEY=Rails.application.credentials.dig(Rails.env.to_sym, :openweathermap, :api_key)
  COUNTRY_CODE="US"
  GEO_BASE_URL = "http://api.openweathermap.org/geo/1.0/zip"
  DATA_BASE_URL = "https://api.openweathermap.org/data/3.0/onecall"

  def initialize(zip_code:, units: "imperial")
    @zip_code = zip_code
    @units = units
  end

  def call
    weather
  end

  private

  attr_reader :units, :zip_code

  def weather
    uri_result(data_uri)
  end

  def uri_result(uri)
    result = Net::HTTP.get_response(uri)
    JSON.parse(result.body)
  end

  # Example return value:
  # {"zip"=>"68502", "name"=>"Lincoln", "lat"=>40.7893, "lon"=>-96.6938, "country"=>"US"}
  def coordinates
    return @coordinates if defined? @coordinates

    @coordinates = uri_result(geo_uri)
  end

  # https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}
  def data_uri
    return @data_uri if defined? @data_uri

    lon = coordinates["lon"]
    lat = coordinates["lat"]

    @data_uri = URI(DATA_BASE_URL)
    params = { lat: lat, lon: lon, units: units, appid: OWM_API_KEY }
    @data_uri.query = URI.encode_www_form(params)

    @data_uri
  end

  # http://api.openweathermap.org/geo/1.0/zip?zip={zip code},{country code}&appid={API key}
  def geo_uri
    return @geo_uri if defined? @geo_uri

    @geo_uri = URI(GEO_BASE_URL)
    params = { zip: "#{zip_code},#{COUNTRY_CODE}", appid: OWM_API_KEY }
    @geo_uri.query = URI.encode_www_form(params)

    @geo_uri
  end
end
