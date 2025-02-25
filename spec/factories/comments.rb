FactoryBot.define do
  factory :comment do
    association :user
    association :article
    body { "test." }
  end
end