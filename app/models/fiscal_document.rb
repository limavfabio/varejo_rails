class FiscalDocument < ApplicationRecord
  belongs_to :company
  belongs_to :fiscal_scenario
  belongs_to :customer
  has_many :document_items, dependent: :destroy
  has_many :document_payments, dependent: :destroy
  has_many :products, through: :document_items

  accepts_nested_attributes_for :document_items, allow_destroy: true
  accepts_nested_attributes_for :document_payments, allow_destroy: true

  validates :description, presence: true, length: { minimum: 3, maximum: 255 }
  validates :document_items, presence: true
  validates :document_payments, presence: true

  before_save :calculate_total_value

  def venda?
    fiscal_scenario.operation == "venda"
  end
  def self.ransackable_attributes(auth_object = nil)
    [ "company_id", "created_at", "customer_id", "id", "total_price", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "company", "customer", "document_payments", "document_items" ]
  end

  def calculate_total_value
    self.total_value = document_items.sum do |item|
      item.product.retail_price * item.quantity
    end
  end
end
