module Billetto
  # Stands in for Client in development and specs so we never need a real
  # API key to see or test the ingestion pipeline. Same interface as Client,
  # same normalized shape - callers can't tell the difference.
  class FakeClient
    SAMPLE_EVENTS = [
      {
        external_id: "sample-1",
        title: "Ruby on Rails Meetup",
        description: "A casual meetup for Rails developers to share what they're building.",
        starts_at: 3.days.from_now.change(hour: 18, min: 30),
        image_url: "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4",
        source_url: "https://billetto.com/events/sample-1",
      },
      {
        external_id: "sample-2",
        title: "Copenhagen Startup Night",
        description: "Founders and early employees swapping stories over drinks.",
        starts_at: 10.days.from_now.change(hour: 19, min: 0),
        image_url: "https://images.unsplash.com/photo-1511578314322-379afb476865",
        source_url: "https://billetto.com/events/sample-2",
      },
      {
        external_id: "sample-3",
        title: "Live Jazz Night",
        description: "An evening of live jazz from local and touring bands.",
        starts_at: 20.days.from_now.change(hour: 20, min: 0),
        image_url: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f",
        source_url: "https://billetto.com/events/sample-3",
      },
    ].freeze

    def list_public_events(limit: 50)
      SAMPLE_EVENTS.first(limit)
    end
  end
end
