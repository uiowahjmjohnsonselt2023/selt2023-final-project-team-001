class Promotions::FixedAmount < ApplicationRecord
  include Promotionable

  monetize :amount_cents, numericality: {greater_than: 0}
end
