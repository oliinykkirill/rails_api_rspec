FactoryBot.define do
  factory :order do
    user
    total { 99.99 }
  end
end
