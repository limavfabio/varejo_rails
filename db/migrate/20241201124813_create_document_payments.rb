class CreateDocumentPayments < ActiveRecord::Migration[8.0]
  def change
    create_table :document_payments do |t|
      t.references :fiscal_document, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end
