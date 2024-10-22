# Presentation model for weather api data (not ActiveRecord)
#
# @see WeatherService

class Weather
  def initialize(address:)
    @data = WeatherService.call(address: address)
    puts "Weather data: #{@data}"
  end

  def icon_url    = data[:icon_url]
  def status      = current_weather[:main]
  def description = current_weather[:description]
  def temperature = data.dig(:current, :temp)
  def high        = data[:daily].first[:temp][:max]
  def low         = data[:daily].first[:temp][:min]
  def feels_like  = data.dig(:current, :feels_like)
  def humidity    = data.dig(:current, :humidity)
  def wind_speed  = data.dig(:current, :wind_speed)
  def cached?     = data[:results_cached]
  def name        = data.dig(:geo, :name)
  def latitude    = data.dig(:geo, :latitude)
  def longitude   = data.dig(:geo, :longitude)

  private

  attr_reader :data

  def current_weather = data[:current][:weather].first
end
