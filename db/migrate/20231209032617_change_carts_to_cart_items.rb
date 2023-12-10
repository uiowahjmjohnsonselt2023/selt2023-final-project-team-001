class ChangeCartsToCartItems < ActiveRecord::Migration[7.1]
  def change
    rename_table :carts, :cart_items
    remove_index :cart_items, column: [:user_id, :product_id], unique: true
    remove_reference :cart_items, :user, index: true, foreign_key: true
  end
end
