class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :role, null: false, default: 0  # 0 = user, 1 = delegate, 2 = administrator
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false

      t.boolean :verified, null: false, default: false

      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
