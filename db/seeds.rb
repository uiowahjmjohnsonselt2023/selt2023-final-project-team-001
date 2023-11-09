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
