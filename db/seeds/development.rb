require "faker"

random = Random.new(43110)
Faker::Config.random = random
conditions = Product.conditions.values
category_ids = Category.pluck(:id)

Product.destroy_all
# Categorizations should be destroyed with the products, but just to be safe
Categorization.destroy_all

Product.insert_all(
  100.times.map do
    # saved separately to ensure created_at < updated_at
    created_at = Faker::Time.backward
    {
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph(sentence_count: 2),
      price_cents: Faker::Number.within(range: 1..1000_00), # $0.01 to $1000.00
      quantity: Faker::Number.within(range: 1..100),
      condition: Faker::Base.sample(conditions),
      private: Faker::Boolean.boolean,
      created_at:,
      updated_at: Faker::Time.between(from: created_at, to: Time.now)
    }
  end
)

max_num_categories = [5, category_ids.length].min
Categorization.insert_all(
  Product.pluck(:id).flat_map do |product_id|
    num_categories = Faker::Number.within(range: 1..max_num_categories)
    Faker::Base.sample(category_ids, num_categories).map do |category_id|
      {product_id:, category_id:}
    end
  end
)
