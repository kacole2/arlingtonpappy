json.array!(@items) do |item|
  json.extract! item, :id, :pappypresent, :ordersent, :textsent
  json.url item_url(item, format: :json)
end
