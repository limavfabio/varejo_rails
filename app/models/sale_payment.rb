class SalePayment < ApplicationRecord
  belongs_to :sale
  belongs_to :payment_method
end
