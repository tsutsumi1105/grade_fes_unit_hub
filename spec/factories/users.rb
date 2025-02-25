FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    name { "Test User" }
  end
end