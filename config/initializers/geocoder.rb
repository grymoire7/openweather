Geocoder.configure(
  lookup: :geoapify,
  api_key: Rails.application.credentials.development.geoapify.api_key
)
