# Controller for the home page.

class HomeController < ApplicationController
  # Our default address is Cupertino, a common default for mac users.
  DEFAULT_ADDRESS = "1 Infinite Loop, Cupertino, CA 95014"

  def index
    data = WeatherService.call(address: address)
    @weather = Weather.new(data)
  rescue StandardError => e
    flash.now[:alert] = e.to_s
    # raise e
  end

  private

  def address
    params[:address] || DEFAULT_ADDRESS
  end
end
