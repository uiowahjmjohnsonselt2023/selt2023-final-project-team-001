# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

users = [
  {
    first_name: "admin",
    last_name: "admin",
    email: "admin@admin.com",
    password: "admin000",
    password_confirmation: "admin000",
    is_seller: false,
    is_buyer: false,
    is_admin: true
  },
  {
    first_name: "admin2",
    last_name: "admin2",
    email: "admin2@admin.com",
    password: "admin2000",
    password_confirmation: "admin2000",
    is_seller: false,
    is_buyer: false,
    is_admin: true
  }
]

users.each do |user_attributes|
  user = User.create_with(user_attributes).find_or_create_by!(email: user_attributes[:email])
  # Explicitly define user_attributes within the loop
  profile_attributes = {
    bio: Faker::Lorem.paragraph(sentence_count: 2),
    location: Faker::Address.city,
    first_name: user_attributes[:first_name],
    last_name: user_attributes[:last_name],
    birth_date: Faker::Date.between(from: 40.years.ago, to: 18.years.ago),
    twitter: "https://x.com/#{Faker::Internet.username}",
    facebook: "https://facebook.com/#{Faker::Internet.username}",
    instagram: "https://instagram.com/#{Faker::Internet.username}",
    website: Faker::Internet.url,
    occupation: Faker::Job.title,
    seller_rating: Faker::Number.between(from: 1, to: 5),
    buyer_rating: Faker::Number.between(from: 1, to: 5),
    public_profile: true,
    user: user
  }

  Profile.create!(profile_attributes)
end

# This file should contain all the record creation needed to seed the database
# with its default values, regardless of environment. For environment-specific
# seeds, see the "db/seeds" directory.

# Taken from eBay.
categories = [
  "Motors",
  "Electronics",
  "Collectibles & Art",
  "Home & Garden",
  "Clothing, Shoes & Accessories",
  "Toys & Hobbies",
  "Sporting Goods",
  "Books, Movies & Music",
  "Health & Beauty",
  "Business & Industrial",
  "Jewelry & Watches",
  "Baby Essentials",
  "Pet Supplies"
]
categories.each do |category|
  Category.find_or_create_by!(name: category)
end

# Per-environment seeds.
# https://stackoverflow.com/a/27929924
puts "Loading #{Rails.env.downcase} seeds..."
begin
  load(Rails.root.join("db", "seeds", "#{Rails.env.downcase}.rb"))
rescue LoadError
  puts "No seed file for #{Rails.env} environment."
end
