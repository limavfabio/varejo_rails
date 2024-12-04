json.extract! fiscal_document, :id, :customer_id, :fiscal_scenario_id, :company_id,
  :description, :total_value, :created_at, :updated_at
json.url fiscal_document_url(fiscal_document, format: :json)
