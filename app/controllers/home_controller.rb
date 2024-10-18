# Controller for home page

class HomeController < ApplicationController

  def index
    zip_code = '68502'
    @data = WeatherService.new(zip_code: zip_code)
    # raise
  end
end

