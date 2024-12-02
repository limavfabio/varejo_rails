class CreateDocumentItems < ActiveRecord::Migration[8.0]
  def change
    create_table :document_items do |t|
      t.references :fiscal_document, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
