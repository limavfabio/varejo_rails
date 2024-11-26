class AddTenantIdToCustomers < ActiveRecord::Migration[8.0]
  def change
    add_reference :customers, :tenant, null: false, foreign_key: true
  end
end
