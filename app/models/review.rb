class Review < ApplicationRecord
  validates :interaction_rating, presence: true, inclusion: {in: 1..5}
end
