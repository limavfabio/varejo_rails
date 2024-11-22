class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :cost_price
      t.decimal :retail_price

      t.timestamps
    end
  end
end
