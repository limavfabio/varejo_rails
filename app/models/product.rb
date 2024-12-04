class Product < ApplicationRecord
  belongs_to :company

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 200 }
  validates :retail_price, numericality: { greater_than: 0 }
  validates :cost_price, numericality: { greater_than: 0, allow_nil: true }

  def self.ransackable_attributes(auth_object = nil)
    [ "company_id", "cost_price", "created_at", "description", "id", "name", "retail_price", "updated_at" ]
  end
end
