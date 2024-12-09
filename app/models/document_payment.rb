class DocumentPayment < ApplicationRecord
  belongs_to :fiscal_document
  belongs_to :payment_method

  validates :amount_cents, numericality: {greater_than: 0, only_integer: true}

  def amount
    amount_cents.to_d / 100
  end
end
