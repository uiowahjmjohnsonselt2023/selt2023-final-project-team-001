class AddCartRefToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :cart, foreign_key: {to_table: :carts}
  end
end
