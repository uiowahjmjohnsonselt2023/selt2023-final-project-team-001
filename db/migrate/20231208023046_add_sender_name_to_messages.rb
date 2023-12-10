class AddSenderNameToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :sender_name, :string, null: false, default: ""
  end
end
