class Review < ApplicationRecord
  belongs_to :reviewer, class_name: "User", foreign_key: "reviewer_id"
  belongs_to :seller, class_name: "User", foreign_key: "seller_id"
  validates :has_purchased_from, presence: true
  validates :interaction_rating, presence: true, inclusion: {in: 1..5}
  validates :description, length: {maximum: 2000, allow_blank: true}
end
