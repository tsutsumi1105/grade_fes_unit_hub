FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test_#{n}@example.com" }
    sequence(:name) { |n| "Test User #{n}" }
    password { "password" }
    password_confirmation { "password" }
  end
end