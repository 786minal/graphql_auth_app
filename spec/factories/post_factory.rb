FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence(word_count: 3)}
    description {Faker::Lorem::paragraph(sentence_count: 3)}
    association :user
  end
end