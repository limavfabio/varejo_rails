class Company < ApplicationRecord
  has_many :customers
  has_many :fiscal_documents
  has_many :payment_methods

  validates :name, presence: true
end
