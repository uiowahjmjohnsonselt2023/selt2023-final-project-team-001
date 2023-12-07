class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :sender, index: true, foreign_key: {to_table: :users}, null: false
      t.references :receiver, index: true, foreign_key: {to_table: :users}, null: false
      t.text :subject, null: false, default: ""
      t.text :message, null: false, default: ""
      t.timestamps

      t.index [:sender, :receiver, :subject, :message], unique: true
    end
  end
end
