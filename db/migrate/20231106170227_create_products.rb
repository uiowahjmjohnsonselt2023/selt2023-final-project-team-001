class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false, default: ""
      t.text :description, null: false, default: ""
      t.monetize :price, null: false, default: 1
      t.integer :quantity, null: false, default: 1
      t.integer :condition, null: false, default: 400 # enum, default is new
      t.boolean :private, null: false, default: false
      t.timestamps
    end
  end
end
