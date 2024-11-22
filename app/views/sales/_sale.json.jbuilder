json.extract! sale, :id, :customer_id, :total_value, :created_at, :updated_at
json.url sale_url(sale, format: :json)
