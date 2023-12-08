class CreatePromotions < ActiveRecord::Migration[7.1]
  def change
    create_table :promotions do |t|
      t.string :name
      t.datetime :starts_on, null: false
      t.datetime :ends_on, null: false
      # indicates whether the deal can be applied multiple times to the same order
      t.boolean :multiple, null: false, default: true
      t.string :promotionable_type
      t.integer :promotionable_id
      t.timestamps
    end
  end
end
