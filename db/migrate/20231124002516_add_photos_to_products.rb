class AddPhotosToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :photos, :json
  end
end
