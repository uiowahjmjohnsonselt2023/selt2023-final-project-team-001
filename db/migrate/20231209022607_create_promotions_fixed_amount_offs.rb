class CreatePromotionsFixedAmountOffs < ActiveRecord::Migration[7.1]
  def change
    create_table :promotions_fixed_amount_offs do |t|
      t.monetize :amount, null: false
      t.timestamps
    end
  end
end
