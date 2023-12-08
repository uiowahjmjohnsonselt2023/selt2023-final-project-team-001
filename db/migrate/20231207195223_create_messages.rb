class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :sender, index: true, foreign_key: {to_table: :users}, null: false
      t.references :receiver, index: true, foreign_key: {to_table: :users}, null: false
      t.text :subject, null: false
      t.text :message, null: false
      t.timestamps
    end
  end
end
