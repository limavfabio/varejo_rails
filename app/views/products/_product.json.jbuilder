json.extract! product, :id, :name, :description, :cost_price_cents, :retail_price_cents, :created_at, :updated_at
json.url product_url(product, format: :json)
