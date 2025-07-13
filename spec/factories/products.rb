FactoryBot.define do
  factory :product do
    title { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 1.0..100.0) }
    quantity { 10 }
    published { true }
    user
  end
end
