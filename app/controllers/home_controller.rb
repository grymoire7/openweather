# Controller for the home page.

class HomeController < ApplicationController
  # Our default zip code is Cupertino, a common default for mac users.
  DEFAULT_ZIP_CODE = "95014"

  def index
    data = WeatherService.new(zip_code: zip_code).call
    @weather = Weather.new(data)
  end

  private

  def zip_code
    params[:q] || DEAFAULT_ZIP_CODE
  end
end
