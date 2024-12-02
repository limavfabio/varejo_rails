class FiscalScenario < ApplicationRecord
  belongs_to :company
  has_many :fiscal_documents

  validates :description, :operation, :operation_type, presence: true

  enum :operation, [ :compra, :venda ]
  enum :operation_type, [ :entrada, :saida ]
end

# t.string "description"
# t.integer "operation"
# t.integer "operation_type"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
