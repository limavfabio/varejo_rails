class DocumentItem < ApplicationRecord
  belongs_to :fiscal_document
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0, only_integer: true }
end
