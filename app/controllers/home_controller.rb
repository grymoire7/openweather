# Controller for the home page.

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
    params[:address] || DEFAULT_ADDRESS
  end
end
