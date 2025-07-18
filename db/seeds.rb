Product.delete_all
User.delete_all

3.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: "password123"
  )
  puts "Created user: #{user.email}"

  2.times do
    product = Product.create!(
      title: Faker::Commerce.product_name,
      price: rand(1.0..100.0).round(2),
      published: true,
      user_id: user.id
    )
    puts "Created product: #{product.title} ($#{product.price})"
  end
end
