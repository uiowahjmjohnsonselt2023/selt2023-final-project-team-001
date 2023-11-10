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

  factory :user_with_profile, parent: :user do
    after(:create) do |user|
      create(:profile, user: user)
    end
  end

  factory :user_with_public_profile, parent: :user do
    after(:create) do |user|
      create(:profile, user: user, public_profile: true)
    end
  end

  factory :user_with_private_profile, parent: :user do
    after(:create) do |user|
      create(:profile, user: user, public_profile: false)
    end
  end
end
