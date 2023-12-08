class AddMinAndMaxToPromotions < ActiveRecord::Migration[7.1]
  def change
    # Minimum number of items required to qualify for the promotion
    add_column :promotions, :min_quantity, :integer, null: false, default: 1
    # Maximum number of items that can be discounted by the promotion
    add_column :promotions, :max_quantity, :integer, null: false, default: 1
  end
end
