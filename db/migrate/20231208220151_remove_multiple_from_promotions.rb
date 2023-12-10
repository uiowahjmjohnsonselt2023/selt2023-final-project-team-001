class RemoveMultipleFromPromotions < ActiveRecord::Migration[7.1]
  def change
    remove_column :promotions, :multiple, :boolean
  end
end
