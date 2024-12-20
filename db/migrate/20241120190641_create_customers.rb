class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address

      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
