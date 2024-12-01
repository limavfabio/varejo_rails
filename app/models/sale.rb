class Sale < ApplicationRecord
  belongs_to :company
  belongs_to :customer
  has_many :sale_products
  has_many :sale_payments

  def self.ransackable_attributes(auth_object = nil)
    [ "company_id", "created_at", "customer_id", "id", "total_price", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "company", "customer", "sale_payments", "sale_products" ]
  end
end
