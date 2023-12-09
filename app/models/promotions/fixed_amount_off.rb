class Promotions::FixedAmountOff < ApplicationRecord
  include Promotions::Promotionable

  monetize :amount_cents, numericality: {greater_than: 0}
end
