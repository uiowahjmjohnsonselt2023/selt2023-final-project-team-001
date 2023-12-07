FactoryBot.define do
  factory :storefront do
    association :user
    custom_code { Faker::Lorem.word } # Assuming custom_code is a string attribute
    sequence(:name) { |n| "Storefront #{n}" }
    short_description { "This is my storefront." }
  end
end
