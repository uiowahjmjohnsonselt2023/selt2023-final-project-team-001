class CreateProductsPromotionsJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :products, :promotions do |t|
      t.index :product_id
      t.index :promotion_id
    end
  end
end
