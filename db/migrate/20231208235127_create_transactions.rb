class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :buyer, null: false, foreign_key: true
      t.references :seller, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :price_cents, null: false, default: 1
      t.string :shipping_status, null: false, default: "pending"

      t.timestamps
    end
  end
end
