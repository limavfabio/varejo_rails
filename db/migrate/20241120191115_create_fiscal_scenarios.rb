class CreateFiscalScenarios < ActiveRecord::Migration[8.0]
  def change
    create_table :fiscal_scenarios do |t|
      t.string :description
      t.integer :operation
      t.integer :operation_type

      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
