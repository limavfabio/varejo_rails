class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.references :customer, null: false, foreign_key: true
      t.decimal :total_price

      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
