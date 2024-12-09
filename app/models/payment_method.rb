class PaymentMethod < ApplicationRecord
  belongs_to :company

  validates :name, presence: true, uniqueness: {scope: :company_id},
    length: {minimum: 3, maximum: 50}
end
