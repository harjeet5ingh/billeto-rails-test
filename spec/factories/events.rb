FactoryBot.define do
  factory :event do
    sequence(:external_id) { |n| "billetto-#{n}" }
    title { "Ruby on Rails Meetup" }
    description { "A casual meetup for Rails developers." }
    starts_at { 1.week.from_now }
    image_url { "https://example.com/image.jpg" }
    source_url { "https://billetto.com/events/1" }
  end
end
