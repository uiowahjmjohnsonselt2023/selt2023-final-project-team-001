class CreateTransactionsAndTransactionsProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      # Add columns for other attributes of your transaction
      t.references :seller, {null: false, foreign_key: {to_table: :users}}
      t.references :buyer, {null: false, foreign_key: {to_table: :users}}
      t.timestamps
    end

    create_table :transactions_products do |t|
      t.references :transaction, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity_sold, default: 1
      t.timestamps
    end
  end
end
