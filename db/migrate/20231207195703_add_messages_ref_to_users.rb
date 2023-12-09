class AddMessagesRefToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :message, foreign_key: {to_table: :messages}
  end
end
