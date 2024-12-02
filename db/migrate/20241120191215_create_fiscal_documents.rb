class CreateFiscalDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :fiscal_documents do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :fiscal_scenario, null: false, foreign_key: true
      t.text :description, null: false
      t.decimal :total_value

      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
