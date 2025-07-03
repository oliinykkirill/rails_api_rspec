FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password_digest { "hashed_secret_password" }
  end
end
