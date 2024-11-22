json.extract! sales_product, :id, :sale_id, :product_id, :quantity, :total_price, :created_at, :updated_at
json.url sales_product_url(sales_product, format: :json)
