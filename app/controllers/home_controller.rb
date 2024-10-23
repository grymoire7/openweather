# This a thin controller for the home page.
# It uses the WeatherService to fetch weather data for a given address.
#
# see WeatherService

class HomeController < ApplicationController
  # Our default address is Cupertino, a common default for mac users.
  DEFAULT_ADDRESS = "1 Infinite Loop, Cupertino, CA 95014"

  # GET /
  # The home page.
  def index
    @weather = WeatherService.call(address: address)
  rescue StandardError => e
    flash.now[:alert] = e.to_s
  end

  private

  # @return [String] the address for which to fetch weather data
  def address
    @address = params[:address] || DEFAULT_ADDRESS
  end
end
