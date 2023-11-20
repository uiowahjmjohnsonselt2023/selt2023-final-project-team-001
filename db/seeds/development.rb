require "faker"

random = Random.new(43110)
Faker::Config.random = random

conditions = Product.conditions.values
category_ids = Category.pluck(:id)

password_kwargs = {
  min_length: 10,
  max_length: 20,
  mix_case: true,
  special_characters: true
}

# We don't use #insert_all for users because we need bcrypt to hash the passwords
# (which is done in the model). This is a lot slower unfortunately, but I couldn't
# find a way to get around it. Note: the slow part is model instantiation, not the
# database insertion.
users = 30.times.map do |i|
  email = Faker::Internet.email
  password = Faker::Internet.password(**password_kwargs)
  user = User.find_or_initialize_by(email: email)
  user.update!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: email,
    password: password,
    password_confirmation: password,
    # Ensure that the database has at least 5 sellers and 5 buyers.
    is_seller: i < 5 || Faker::Boolean.boolean,
    is_buyer: (i >= 5 && i < 10) || Faker::Boolean.boolean
  )
  user
end

Profile.insert_all(
  users.map do |user|
    username = Faker::Internet.username(specifier: user.full_name)
    {
      bio: Faker::Lorem.paragraph(sentence_count: 2),
      location: Faker::Address.city,
      first_name: user.first_name,
      last_name: user.last_name,
      birth_date: Faker::Date.birthday(min_age: 18, max_age: 65),
      twitter: "https://x.com/#{username}",
      facebook: "https://facebook.com/#{username}",
      instagram: "https://instagram.com/#{username}",
      website: Faker::Internet.url(path: "/#{username}"),
      occupation: Faker::Job.title,
      seller_rating: Faker::Number.within(range: 1..5),
      buyer_rating: Faker::Number.within(range: 1..5),
      public_profile: Faker::Boolean.boolean,
      user_id: user.id
    }
  end
)

seller_ids = User.sellers.pluck(:id)
Product.insert_all(
  100.times.map do
    # created_at is separate to ensure created_at < updated_at
    created_at = Faker::Time.backward
    {
      name: Faker::Commerce.product_name,
      seller_id: Faker::Base.sample(seller_ids),
      description: Faker::Lorem.paragraph(sentence_count: 2),
      price_cents: Faker::Number.within(range: 1..1000_00), # $0.01 to $1000.00
      quantity: Faker::Number.within(range: 1..100),
      condition: Faker::Base.sample(conditions),
      private: Faker::Boolean.boolean,
      created_at: created_at,
      updated_at: Faker::Time.between(from: created_at, to: Time.now)
    }
  end
)

# Create categorizations for each product
max_num_categories = [5, category_ids.length].min
Categorization.insert_all(
  Product.pluck(:id).flat_map do |product_id|
    num_categories = Faker::Number.within(range: 1..max_num_categories)
    Faker::Base.sample(category_ids, num_categories).map do |category_id|
      {product_id: product_id, category_id: category_id}
    end
  end
)

# Create carts for a couple users
User.create!({first_name: "Judy",
           last_name: "Rudy",
           email: "judy@rudy.com",
           password: "judyrudy100",
           password_confirmation: "judyrudy100",
           is_seller: false,
           is_buyer: true,
           is_admin: false})

Cart.create!({user_id: User.find_by(email: "judy@rudy.com").id, product_id: 1})
