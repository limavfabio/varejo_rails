class FiscalDocument < ApplicationRecord
  belongs_to :company
  belongs_to :fiscal_scenario
  belongs_to :customer, optional: true
  has_many :document_items, dependent: :destroy
  has_many :document_payments, dependent: :destroy
  has_many :products, through: :document_items

  accepts_nested_attributes_for :document_items, allow_destroy: true
  accepts_nested_attributes_for :document_payments, allow_destroy: true

  validates :description, presence: true, length: {minimum: 3, maximum: 255}
  validates :document_items, presence: true
  validates :document_payments, presence: true
  validates :total_value_cents, numericality: {greater_than: 0, only_integer: true}

  before_save :calculate_total_value_cents

  def total_value
    total_value_cents.to_d / 100
  end

  def venda?
    fiscal_scenario.operation == "venda"
  end

  default_scope { where(company_id: Current.user&.company_id) if Current.user }

  def self.ransackable_attributes(auth_object = nil)
    ["company_id", "created_at", "customer_id", "id", "total_price", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["company", "customer", "document_payments", "document_items"]
  end

  def calculate_total_value_cents
    self.total_value_cents = document_items.sum do |item|
      item.product.retail_price_cents * item.quantity
    end
  end
end
