# README

This is a weather forecast application that takes an address as input and
retrieves forecast data for the given address. This includes the current and
high/low temperatures. The application caches the forecast details for 30
minutes for all subsequent requests by zip codes. It displays an indicator if
the result is pulled from cache.

The application was made with Ruby on Rails 7.2.1 and Ruby 3.3.5. It uses the
OpenWeatherMap API to get the weather data and the Geocoder gem with geoapify
to get the latitude and longitude of the address. Typhoeus is used to make
requests to the OpenWeatherMap API.

There is no database for this application. The cache is stored in memory using
Rails.cache.

Rspec is used for testing. The tests are located in the spec folder and can be
run with the command `bundle exec rspec`.

<br/>
<img width="1235" alt="screenshot" src="https://github.com/user-attachments/assets/8fc5a03e-7745-44c7-b60c-4d544c1a2eec">
