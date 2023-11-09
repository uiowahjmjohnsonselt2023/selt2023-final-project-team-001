# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users = [
  {
    first_name: "admin",
    last_name: "admin",
    email: "admin@admin.com",
    password: "admin",
    password_confirmation: "admin",
    is_seller: false,
    is_buyer: false,
    is_admin: true
  },
  {
    first_name: "admin2",
    last_name: "admin2",
    email: "admin2@admin.com",
    password: "admin2",
    password_confirmation: "admin2",
    is_seller: false,
    is_buyer: false,
    is_admin: true
  }
]

users.each do |user|
  User.create!(user)
  
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
