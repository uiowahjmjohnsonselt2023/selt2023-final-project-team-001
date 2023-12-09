class AddHasDeletedFieldsMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :hasSenderDeleted, :boolean, null: false, default: false
    add_column :messages, :hasReceiverDeleted, :boolean, null: false, default: false
  end
end
