class AddHasReadToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :hasRead, :boolean, null: false, default: false
  end
end
