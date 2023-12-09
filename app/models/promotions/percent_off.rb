class Promotions::PercentOff < ApplicationRecord
  include Promotionable

  validates :percentage, numericality: {greater_than: 0, less_than_or_equal_to: 1}
end
