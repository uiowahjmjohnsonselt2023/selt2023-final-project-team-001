class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :reviewer, index: true, foreign_key: {to_table: :users}, null: false
      t.references :seller, index: true, foreign_key: {to_table: :users}, null: false
      t.boolean :has_purchased_from, null: false, default: false
      t.integer :interaction_rating, null: false
      t.text :description
      t.timestamps
    end
  end
end
