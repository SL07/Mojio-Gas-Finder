json.array!(@stations) do |station|
  json.extract! station, :id, :name, :address, :city, :long, :lat, :price
  json.url station_url(station, format: :json)
end
