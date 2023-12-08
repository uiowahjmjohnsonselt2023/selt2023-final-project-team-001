class AddViewsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :views, :integer, null: false, default: 0
  end
end
