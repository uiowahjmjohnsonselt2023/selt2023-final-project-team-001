FactoryBot.define do
  factory :price_alert do
    association :user
    association :product
    threshold { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
