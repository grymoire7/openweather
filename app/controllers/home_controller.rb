# This a thin controller for the home page.
# It uses the Weather model to fetch weather data for a given address.
#
# see models/weather.rb

class HomeController < ApplicationController
  # Our default address is Cupertino, a common default for mac users.
  DEFAULT_ADDRESS = "1 Infinite Loop, Cupertino, CA 95014"

  def index
    @weather = Weather.new(address: address)
  rescue StandardError => e
    flash.now[:alert] = e.to_s
  end

  private

  def address
    @address = params[:address] || DEFAULT_ADDRESS
  end
end
