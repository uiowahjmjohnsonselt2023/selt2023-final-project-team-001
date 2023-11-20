class AddCartRefToProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :cart, foreign_key: {to_table: :carts}
  end
end
