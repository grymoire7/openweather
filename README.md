# README

This is a weather forecast application that takes an address as input and
retrieves current weather data for the given address. The application caches
data from the weather service for 30 minutes for all subsequent requests by zip
code. Similarly, it caches data from the geocoding service for 30 minutes by
address.  It displays indicators if results are pulled from a cache.

The application was made with Ruby on Rails 7.2.1 and Ruby 3.3.5. It uses the
Geocoder gem with the geoapify service to get the latitude and longitude of the
provided address and then the OpenWeatherMap API to get the weather data using
the latitude and longitude. Typhoeus is used to make requests to the
OpenWeatherMap API.

There is no database for this application. The cache is stored in memory using
Rails.cache. This could easily be changed to use a different cache store such
as Redis.

To run the application, clone the repository and run `bundle install` to install
the required gems. Then run `./bin/dev` to start the server. The application can
be accessed at `http://localhost:3000`.  Use `rails dev:cache` to toggle the cache.

Rspec is used for testing. The tests are located in the `spec` folder and can be
run with the command `bundle exec rspec`.

Note: You will also need to set the environment variable `RAILS_MASTER_KEY` to
the value provided in the email for rails to decrypt the service credentials.

To see 'Weather data cached: true' and 'Geocoding data cached: false' first
search for a street address, then search for the zip code from that address.

<br/>
<img width="1235" alt="screenshot" src="https://github.com/user-attachments/assets/8fc5a03e-7745-44c7-b60c-4d544c1a2eec">
