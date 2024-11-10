json.extract! product, :id, :name, :description, :cost_price, :retail_price, :created_at, :updated_at
json.url product_url(product, format: :json)
