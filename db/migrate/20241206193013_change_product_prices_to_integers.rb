class ChangeProductPricesToIntegers < ActiveRecord::Migration[8.0]
  def change
    change_column :products, :cost_price, :integer
    change_column :products, :retail_price, :integer
  end
end
