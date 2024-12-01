class Customer < ApplicationRecord
  belongs_to :company
  has_many :sales

  def self.ransackable_attributes(auth_object = nil)
    [ "address", "company_id", "created_at", "id", "name", "updated_at" ]
  end
end
