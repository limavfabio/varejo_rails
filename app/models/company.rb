class Company < ApplicationRecord
  has_many :customers
  has_many :sales
  has_many :payment_methods

  validates :name, presence: true
end
