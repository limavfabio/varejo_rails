json.extract! sales_payment_method, :id, :sale_id, :payment_method_id, :amount, :created_at, :updated_at
json.url sales_payment_method_url(sales_payment_method, format: :json)
