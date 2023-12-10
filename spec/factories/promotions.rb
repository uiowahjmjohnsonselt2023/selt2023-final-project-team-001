FactoryBot.define do
  factory :promotion do
    seller
    starts_on { Time.now.beginning_of_year }
    ends_on { Time.now.end_of_year }
    min_quantity { 1 }
    max_quantity { 0 }

    trait(:not_started) { starts_on { Time.now.tomorrow } }
    trait(:ended) { ends_on { Time.now.yesterday } }

    trait(:with_products) do
      transient { products_count { 1 } }

      after(:create) do |promotion, evaluator|
        create_list(
          :product,
          evaluator.products_count,
          promotions: [promotion],
          seller: promotion.seller
        )
      end
    end

    factory :promotion_with_products, traits: [:with_products]

    factory :percent_off do
      transient { percentage { 0.5 } }
      promotionable_type { "Promotions::PercentOff" }
      promotionable_attributes { {percentage: percentage} }
    end

    factory :fixed_amount_off do
      transient { amount { 5 } }
      promotionable_type { "Promotions::FixedAmountOff" }
      promotionable_attributes { {amount: amount} }
    end
  end
end
