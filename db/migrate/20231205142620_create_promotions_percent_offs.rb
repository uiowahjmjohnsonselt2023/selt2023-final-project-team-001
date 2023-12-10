class CreatePromotionsPercentOffs < ActiveRecord::Migration[7.1]
  def change
    create_table :promotions_percent_offs do |t|
      t.integer :percentage, null: false
      t.timestamps
    end
  end
end
