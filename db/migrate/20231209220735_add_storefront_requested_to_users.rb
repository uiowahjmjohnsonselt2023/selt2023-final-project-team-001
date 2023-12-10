class AddStorefrontRequestedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :storefront_requested, :integer
    add_column :users, :request_time, :datetime
  end
end
