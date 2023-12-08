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
    first_name: "Thomas",
    last_name: "Anderson",
    email: "admin@admin.com",
    password: "admin000!P",
    password_confirmation: "admin000!P",
    is_seller: true,
    is_buyer: true,
    is_admin: true,
    profile_attributes: {
      bio: "I go by the hacker alias Neo and am guilty of virtually every" \
        " computer crime there is a law for.",
      location: "Lower Downtown, Capital City, USA",
      first_name: "Thomas",
      last_name: "Anderson",
      birth_date: "March 11, 1962",
      twitter: "https://x.com/neo",
      website: "https://neo.com",
      occupation: "Programmer",
      public_profile: true
    },
    storefront_attributes: {
      name: "Neo's (Candy) Pills",
      short_description: "I sell red and blue pills. The red pills are" \
        " delicious cinnamon candy, and the blue pills are scrumptious blue" \
        " raspberry candy. They're not drugs, I promise!",
      custom_code: 2
    }
  },
  {
    first_name: "John",
    last_name: "Doe",
    email: "jdoe@example.com",
    password: "JohnDoe123!P",
    password_confirmation: "JohnDoe123!P",
    is_seller: true,
    is_buyer: true,
    is_admin: false,
    profile_attributes: {
      bio: "Hi! I'm John. I sell and buy pretty much anything, so feel free" \
        " to shoot me a message :)",
      location: "New York, NY",
      first_name: "John",
      last_name: "Doe",
      birth_date: "January 4, 1990",
      facebook: "https://facebook.com/jdoeAuctions",
      instagram: "https://instagram.com/jdoeAuctions",
      website: "https://jdoeAuctions.example",
      occupation: "Auctioneer",
      seller_rating: 0,
      public_profile: true
    },
    storefront_attributes: {
      name: "jdoe Auctions",
      short_description: "I sell pretty much anything, so feel free to shoot" \
        " me a message :)",
      custom_code: 2
    }
  }
]

users.each do |user_attributes|
  User.create_with(user_attributes).find_or_create_by!(email: user_attributes[:email])
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
