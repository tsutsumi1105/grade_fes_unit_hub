FactoryBot.define do
  factory :article do
    association :user
    title { "title" }
    body { "body" }

    after(:build) do |article|
      article.thumbnail.attach(
        io: File.open(Rails.root.join("spec/fixtures/sample_thumbnail.png")),
        filename: "sample_thumbnail.png",
      )
    end
  end
end