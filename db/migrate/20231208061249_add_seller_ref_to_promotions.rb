class AddSellerRefToPromotions < ActiveRecord::Migration[7.1]
  def change
    add_reference :promotions, :seller, null: false, foreign_key: {to_table: :users}
  end
end
