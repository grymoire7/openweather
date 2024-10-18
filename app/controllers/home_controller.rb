# Controller for home page

class HomeController < ApplicationController
  # https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}
  # http://api.openweathermap.org/geo/1.0/zip?zip={zip code},{country code}&appid={API key}
  #
  OWM_API_KEY=Rails.application.credentials.dig(:openweathermap, :api_key)

  def index
    zip_code = '68502'
    @data = weather_by_zip(zip_code)
    # raise
  end

  private

  def coord_by_zip(zip_code)
    url = "http://api.openweathermap.org/geo/1.0/zip?zip=#{zip_code},US&appid=#{OWM_API_KEY}"
    # {"zip"=>"68502", "name"=>"Lincoln", "lat"=>40.7893, "lon"=>-96.6938, "country"=>"US"}
    url_result(url)
  end

  def weather_by_zip(zip_code)
    coord = coord_by_zip(zip_code)
    weather_by_coord(coord)
  end

  def weather_by_coord(coord)
    url = "https://api.openweathermap.org/data/3.0/onecall?lat=#{coord['lat']}&lon=#{coord['lon']}&appid=#{OWM_API_KEY}"
    url_result(url)
  end

  def url_result(url)
    uri = URI(url)
    result = Net::HTTP.get_response(uri)
    JSON.parse(result.body)
  end
end

