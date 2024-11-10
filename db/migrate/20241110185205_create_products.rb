class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.float :cost_price
      t.float :retail_price

      t.timestamps
    end
  end
end
