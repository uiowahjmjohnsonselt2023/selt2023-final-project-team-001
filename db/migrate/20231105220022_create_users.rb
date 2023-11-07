class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :password_digest_confirmation
      t.boolean :is_seller, null: false, default: false
      t.boolean :is_buyer, null: false, default: false
      t.boolean :is_admin, null: false, default: false
      t.timestamps
    end
  end
end
