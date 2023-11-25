FactoryBot.define do
  factory :storefront do
    association :user
    custom_code { Faker::Lorem.word } # Assuming custom_code is a string attribute

    # Add other attributes and their respective default values as needed
  end
end
