FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "test#{n}" }
    sequence(:last_name) { |n| "user#{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait(:seller) { is_seller { true } }
    trait(:buyer) { is_buyer { true } }
    trait(:admin) { is_admin { true } }

    factory :seller, traits: [:seller]
    factory :buyer, traits: [:buyer]
    factory :admin, traits: [:admin]
  end
end
