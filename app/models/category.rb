class Category < ApplicationRecord
  belongs_to :company
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  has_many :products

  default_scope { where(company_id: Current.user&.company_id) if Current.user }

  validates :name, presence: true, uniqueness: {scope: :company_id}
end
