class Company < ApplicationRecord
  has_many :customers
  has_many :sales

  validates :name, presence: true
end
