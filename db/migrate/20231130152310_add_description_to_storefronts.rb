class AddDescriptionToStorefronts < ActiveRecord::Migration[7.1]
  def change
    add_column :storefronts, :short_description, :text, null: false, default: ""
  end
end
