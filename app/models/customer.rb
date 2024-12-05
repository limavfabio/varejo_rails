class Customer < ApplicationRecord
  belongs_to :company
  has_many :fiscal_documents

  def self.ransackable_attributes(auth_object = nil)
    ["address", "company_id", "created_at", "id", "name", "updated_at"]
  end

  default_scope { where(company_id: Current.user&.company_id) if Current.user }
end
