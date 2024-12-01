class SalePayment < ApplicationRecord
  belongs_to :sale
  belongs_to :payment_method

  validates :amount, numericality: { greater_than: 0 }
end
