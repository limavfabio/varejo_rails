class Product < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: {  maximum: 200 }
  validates :retail_price, numericality: { greater_than: 0 }
  validates :cost_price, numericality: { greater_than: 0, allow_nil: true }
end
