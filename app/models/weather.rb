# Presentation model for weather api data (not ActiveRecord)

class Weather
  def initialize(data)
    @data = data.with_indifferent_access
  end

  def icon_url = "http://openweathermap.org/img/wn/#{current_weather['icon']}@2x.png"

  def status = current_weather[:main]

  def description = current_weather[:description]

  def temperature = data.dig(:current, :temp)
  def high = data[:daily].first[:temp][:max]
  def low = data[:daily].first[:temp][:min]

  def feels_like = data.dig(:current, :feels_like)
  def humidity = data.dig(:current, :humidity)
  def wind_speed = data.dig(:current, :wind_speed)

  def cached? = data[:results_cached]

  def name = data.dig(:geo, :name)

  private

  attr_reader :data

  def current_weather = data[:current][:weather].first
end
