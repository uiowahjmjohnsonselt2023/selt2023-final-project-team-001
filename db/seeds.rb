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
    is_buyer: false
  }
]

users.each do |user|
  User.create!(user)
end
