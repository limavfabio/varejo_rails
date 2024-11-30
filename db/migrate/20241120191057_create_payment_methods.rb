class CreatePaymentMethods < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_methods do |t|
      t.string :name

      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
