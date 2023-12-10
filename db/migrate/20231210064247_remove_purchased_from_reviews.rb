class RemovePurchasedFromReviews < ActiveRecord::Migration[7.1]
  def change
    remove_column :reviews, :has_purchased_from
  end
end
