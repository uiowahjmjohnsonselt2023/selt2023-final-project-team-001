# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    first_name { "test" }
    last_name { "test" }
    email { "test@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
