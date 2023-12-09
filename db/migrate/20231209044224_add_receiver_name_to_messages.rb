class AddReceiverNameToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :receiver_name, :string, null: false
  end
end
