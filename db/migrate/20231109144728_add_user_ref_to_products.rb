class AddUserRefToProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :seller, foreign_key: {to_table: :users}
    # Default to user 1, which should be the admin if the seeds are run.
    # This has to be done after the add_reference because the column will
    # have null values, but there's no way to replace null values with
    # a value in the add_reference call.
    change_column_null :products, :seller_id, false, 1
  end
end
