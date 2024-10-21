class GeocodingService
  def self.call(address)
    response = Geocoder.search(address)
    response or raise IOError.new "Geocoder error"
    response.length > 0 or raise IOError.new "Geocoder is empty"
    data = response.first.data["properties"]
    data or raise IOError.new "Geocoder data error"
    # puts "geocoding data: #{data}"
    data["lat"] or raise IOError.new "Geocoder latitude is missing"
    data["lon"] or raise IOError.new "Geocoder longitude is missing"
    data["city"] or raise IOError.new "Geocoder city is missing"
    data["state"] or raise IOError.new "Geocoder state is missing"
    data["country_code"] or raise IOError.new "Geocoder country code is missing"
    data["postcode"] or raise IOError.new "Geocoder postal code is missing"
    {
      latitude: data["lat"].to_f,
      longitude: data["lon"].to_f,
      city: data["city"],
      state: data["state"],
      name: data["city"] + ", " + data["state"],
      country_code: data["country_code"],
      postal_code: data["postcode"]
    }.with_indifferent_access
  end
end
