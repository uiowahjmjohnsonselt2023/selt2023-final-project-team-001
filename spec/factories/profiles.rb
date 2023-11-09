FactoryBot.define do
  factory :profile do
    bio { "MyText" }
    location { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
    birth_date { "2023-11-09" }
    twitter { "MyString" }
    facebook { "MyString" }
    instagram { "MyString" }
    website { "MyString" }
    occupation { "MyString" }
    seller_rating { 1 }
    buyer_rating { 1 }
    public_profile { false }
    user { nil }
  end
end