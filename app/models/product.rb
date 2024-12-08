class Product < ApplicationRecord
  belongs_to :company

  validates :name, presence: true, length: {maximum: 50}
  validates :description, length: {maximum: 200}
  validates :cost_price, numericality: {greater_than_or_equal_to: 0, allow_nil: true}
  validates :retail_price, numericality: {greater_than: 0}

  def cost_price
    (self[:cost_price] / 100.0) if self[:cost_price]
  end

  def retail_price
    self[:retail_price] / 100.0
  end

  def cost_price=(value)
    super((value.to_f * 100).to_i)
  end

  def retail_price=(value)
    super((value.to_f * 100).to_i)
  end

  default_scope { where(company_id: Current.user&.company_id) if Current.user }

  def self.ransackable_attributes(auth_object = nil)
    ["company_id", "cost_price", "created_at", "description", "id", "name", "retail_price", "updated_at"]
  end
end
