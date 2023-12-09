class AddQuantityToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :quantity, :integer
  end
end
