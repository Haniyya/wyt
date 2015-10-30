json.array!(@newspapers) do |newspaper|
  json.extract! newspaper, :id, :name, :publisher, :feed
  json.url newspaper_url(newspaper, format: :json)
end
