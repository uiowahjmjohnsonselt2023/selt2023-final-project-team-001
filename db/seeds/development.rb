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
      public_profile: user.is_seller || Faker::Boolean.boolean,
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
      quantity: Faker::Number.within(range: 0..100),
      views: Faker::Number.within(range: 0..1000),
      condition: Faker::Base.sample(conditions),
      private: Faker::Boolean.boolean,
      views: Faker::Number.within(range: 0..1000_00), # will stick with max 100,000 views for now
      created_at: created_at,
      updated_at: Faker::Time.between(from: created_at, to: Time.now)
    }
  end
)

# Give half of the sellers a storefront
half_seller_ids = Faker::Base.sample(seller_ids, seller_ids.length / 2)
Storefront.insert_all(
  half_seller_ids.map do |seller_id|
    {
      name: Faker::Company.name,
      short_description: Faker::Company.catch_phrase,
      custom_code: Faker::Number.within(range: 1..2),
      user_id: seller_id
    }
  end
)

# Give some sellers reviews
sellers_to_review = User.sellers.limit(5)
sellers_to_review.each do |seller|
  Review.create!({
    reviewer_id: Faker::Base.sample(User.buyers).id,
    seller_id: seller.id,
    has_purchased_from: Faker::Boolean.boolean,
    interaction_rating: Faker::Number.within(range: 1..5),
    description: Faker::Lorem.paragraph(sentence_count: 2)
  })
  # update the sellers profile to have seller_rating of interaction_rating of the review left, this is usually handled
  # by the review controller but we are not using that here
  seller.profile.update(seller_rating: seller.reviews_for_sellers.average(:interaction_rating).to_i)
end

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

# Default seller
User.create!({first_name: "Seller",
              last_name: "1",
              email: "seller@1.com",
              password: "seller1000!P",
              password_confirmation: "seller1000!P",
              is_seller: true,
              is_buyer: true,
              is_admin: false})
# Create carts
User.create!({first_name: "Judy",
           last_name: "Rudy",
           email: "judy@rudy.com",
           password: "judyrudy100!P",
           password_confirmation: "judyrudy100!P",
           is_seller: false,
           is_buyer: true,
           is_admin: false})

Review.create!({
  reviewer_id: User.find_by(email: "judy@rudy.com").id,
  seller_id: User.find_by(email: "seller@1.com").id,
  has_purchased_from: true,
  interaction_rating: 5,
  description: "meh"
})

Cart.create!({user_id: User.find_by(email: "judy@rudy.com").id, product_id: 1})
Cart.create!({user_id: User.find_by(email: "judy@rudy.com").id, product_id: 2})
Cart.create!({user_id: User.find_by(email: "judy@rudy.com").id, product_id: 3})

Message.create!({receiver_id: User.find_by(email: "judy@rudy.com").id, sender_id: User.find_by(email: "seller@1.com").id, receiver_name: "Judy Rudy",
                 sender_name: "Seller 1", subject: "hello!", message: "hey judy!", hasRead: false})
Message.create!({receiver_id: User.find_by(email: "judy@rudy.com").id, sender_id: User.find_by(email: "seller@1.com").id, receiver_name: "Judy Rudy",
                 sender_name: "Seller 1", subject: "hello!", message: "bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!bye judy!", hasRead: true})

# make one user with a known username and password with products
store_test = User.create!({first_name: "Not",
              last_name: "Real",
              email: "test@storefront.com",
              password: "testing123!P",
              password_confirmation: "testing123!P",
              is_seller: true,
              is_buyer: true,
              is_admin: false})
# use this to add a product to the user
number_of_products = 5 # Adjust as needed
number_of_products.times do
  Product.create!(
    name: Faker::Commerce.product_name,
    seller_id: store_test.id, # Assign the seller ID to the user's ID
    description: Faker::Lorem.paragraph(sentence_count: 2),
    price_cents: Faker::Number.within(range: 1..1000_00), # $0.01 to $1000.00
    quantity: Faker::Number.within(range: 1..100),
    views: Faker::Number.within(range: 1..1000),
    condition: Faker::Base.sample(conditions),
    private: Faker::Boolean.boolean,
    views: Faker::Number.within(range: 0..1000_00), # will stick with max 100,000 views for now
    created_at: Faker::Time.backward,
    updated_at: Faker::Time.between(from: Faker::Time.backward, to: Time.now)
  )
end
