class CreateStorefronts < ActiveRecord::Migration[7.1]
  def change
    create_table :storefronts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :custom_code

      t.timestamps
    end
  end
end
