class CreateCategorizations < ActiveRecord::Migration[7.1]
  def change
    # Not create_join_table because we may want to add
    # additional attributes to the table in the future,
    # which we can't do with a HABTM association.
    create_table :categorizations do |t|
      t.references :product, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps

      # This prevents a product from being in the same category more than once.
      t.index [:product_id, :category_id], unique: true
    end
  end
end
