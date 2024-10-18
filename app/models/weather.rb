# Presentation model for weather api data (not ActiveRecord)

class Weather
  def initialize(data)
    @data = data.with_indifferent_access
  end

  def icon_url
    "http://openweathermap.org/img/wn/#{current_weather['icon']}@2x.png"
  end

  def status
    current_weather[:main]
  end

  def description
    current_weather[:description]
  end

  def temperature
    data.dig(:current, :temp)
  end

  def cached?
    data[:results_cached]
  end

  private

  attr_reader :data

  def current_weather
    data[:current][:weather].first
  end
end
