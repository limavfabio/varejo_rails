class DocumentPayment < ApplicationRecord
  belongs_to :fiscal_document
  belongs_to :payment_method

  validates :amount, numericality: { greater_than: 0 }
end
