class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :quantity, default: 1

      t.index [:user_id, :product_id], unique: true
      t.timestamps
    end
  end
end
