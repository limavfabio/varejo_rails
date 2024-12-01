class CreateSalePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :sale_payments do |t|
      t.references :sale, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end
