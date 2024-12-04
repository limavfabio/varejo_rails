class FiscalScenario < ApplicationRecord
  belongs_to :company
  has_many :fiscal_documents

  validates :description, :operation, :operation_type, presence: true

  enum :operation, [ :compra, :venda ]
  enum :operation_type, [ :entrada, :saida ]
end
