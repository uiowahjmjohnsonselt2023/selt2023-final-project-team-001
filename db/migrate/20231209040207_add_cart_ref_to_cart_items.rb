class AddCartRefToCartItems < ActiveRecord::Migration[7.1]
  def change
    # To handle `null: false` for cart_id, we need to remove all existing cart_items.
    # This obviously wouldn't slide in a real production app, but we don't have any
    # real users or data to worry about.
    CartItem.destroy_all
    add_reference :cart_items, :cart, null: false, foreign_key: true
    add_index :cart_items, [:cart_id, :product_id], unique: true
  end
end
