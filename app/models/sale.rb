class Sale < ApplicationRecord
  belongs_to :customer

  validates :total_price, numericality: { greater_than: 0 }
end
