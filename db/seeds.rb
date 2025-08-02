Product.delete_all
User.delete_all

demo_users = [
  { email: "demo.user1@marketplace.com", password: "password123" },
  { email: "demo.user2@marketplace.com", password: "password123" },
  { email: "demo.user3@marketplace.com", password: "password123" }
]

demo_products = [
  [ "MacBook Pro M3 Max", 2499.99 ],
  [ "Sony WH-1000XM5 Headphones", 349.50 ],
  [ "Keychron Q1 Mechanical Keyboard", 189.00 ],
  [ "Dell UltraSharp 27 4K Monitor", 599.00 ],
  [ "Logitech MX Master 3S Mouse", 99.99 ],
  [ "Ergonomic Office Chair", 399.00 ]
]

product_index = 0

demo_users.each do |user_attrs|
  email = defined?(Faker) ? Faker::Internet.unique.email : user_attrs[:email]
  user = User.create!(
    email: email,
    password: user_attrs[:password]
  )
  puts "Created user: #{user.email}"

  2.times do
    if defined?(Faker)
      title = Faker::Commerce.product_name
      price = rand(1.0..100.0).round(2)
    else
      title, price = demo_products[product_index % demo_products.size]
      product_index += 1
    end

    product = Product.create!(
      title: title,
      price: price,
      published: true,
      user_id: user.id
    )
    puts "Created product: #{product.title} ($#{product.price})"
  end
end
