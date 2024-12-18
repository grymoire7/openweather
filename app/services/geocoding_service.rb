class GeocodingError < StandardError; end

# The GeocodingService class is responsible for fetching the latitude, longitude,
# zip code, and other data of a given address.
# It uses the Geocoder gem with the geoapify API to do this.
#
# @see config/initializers/geocoder.rb
class GeocodingService
  # Fetches geocoding data for a given address.
  #
  # @param address [String] the target address for geocoding data
  # @return [Hash] the geocoding data for the address
  def self.call(address)
    results_cached = true
    results = Rails.cache.fetch("geocoder/address/#{address}", expires_in: 30.minutes, skip_nil: true) do
      results_cached = false

      response = Geocoder.search(address)
      response or raise GeocodingError.new("Cannot reach geocoding service")
      response.length > 0 or raise GeocodingError.new "Address not found"

      data = response.first.data["properties"]
      data or raise(GeocodingError.new("Geocoder data error"))
      data["lat"] or raise GeocodingError.new "Geocoder latitude is missing"
      data["lon"] or raise GeocodingError.new "Geocoder longitude is missing"
      data["city"] or raise(GeocodingError.new("Geocoder city is missing"))
      data["state"] or raise GeocodingError.new("Geocoder state is missing")
      data["country_code"] or raise(GeocodingError.new("Geocoder country code is missing"))
      data["postcode"] or raise(GeocodingError.new("Geocoder postal code is missing"))

      {
        latitude:     data["lat"].to_f,
        longitude:    data["lon"].to_f,
        city:         data["city"],
        state:        data["state"],
        name:         "#{data['city']}, #{data['state']}",
        country_code: data["country_code"],
        postal_code:  data["postcode"]
      }
    end
    results.merge({ results_cached: results_cached }).with_indifferent_access
  end
end
