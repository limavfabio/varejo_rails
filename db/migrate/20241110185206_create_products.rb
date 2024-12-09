class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :cost_price_cents
      t.integer :retail_price_cents

      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
