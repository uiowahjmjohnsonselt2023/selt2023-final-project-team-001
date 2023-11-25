FactoryBot.define do
  # product_without_seller is needed for testing the create action (since the seller is
  # set automatically by the controller and not a permissible parameter)
  factory :product_without_seller, class: "Product" do
    sequence(:name) { |n| "Product #{n}" }
    description { "This is a product description" }
    price { 1 }
    quantity { 1 }
    condition { :new }
    # photos { [Rack::Test::UploadedFile.new(Rails.root.join("spec/support/images/product.png"), "image/png")] }

    factory :product do
      seller
    end
  end
end
