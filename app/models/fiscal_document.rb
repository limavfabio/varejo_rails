class FiscalDocument < ApplicationRecord
  belongs_to :company
  belongs_to :fiscal_scenario
  belongs_to :customer
  has_many :document_items
  has_many :document_payments

  def self.ransackable_attributes(auth_object = nil)
    [ "company_id", "created_at", "customer_id", "id", "total_price", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "company", "customer", "document_payments", "document_items" ]
  end
end
