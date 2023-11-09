class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.text :bio
      t.string :location
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.string :twitter
      t.string :facebook
      t.string :instagram
      t.string :website
      t.string :occupation
      t.integer :seller_rating
      t.integer :buyer_rating
      t.boolean :public_profile, null: false, default: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
