class CreatePriceAlerts < ActiveRecord::Migration[7.1]
  def change
    create_table :price_alerts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :threshold, precision: 10, scale: 2
      t.timestamps
    end
  end
end
