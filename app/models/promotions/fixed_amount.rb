class Promotions::FixedAmount < ApplicationRecord
  include Promotionable

  validates :amount, numericality: {greater_than: 0}
end
