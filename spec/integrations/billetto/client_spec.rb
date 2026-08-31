require "rails_helper"

RSpec.describe Billetto::Client do
  subject(:client) { described_class.new(base_url: "https://billetto.dk/api/v3/", api_key: "test-key") }

  describe "#list_public_events" do
    it "normalizes a successful response into plain event hashes" do
      stub_request(:get, "https://billetto.dk/api/v3/public/events")
        .with(query: { "limit" => "50" }, headers: { "Api-Keypair" => "test-key" })
        .to_return(
          status: 200,
          headers: { "Content-Type" => "application/json" },
          body: {
            events: [
              {
                id: 42,
                title: "Ruby Meetup",
                description: "Talks and pizza",
                startdate: "2026-09-01T18:00:00Z",
                image_link: "https://example.com/image.jpg",
                url: "https://billetto.com/events/42"
              }
            ]
          }.to_json
        )

      events = client.list_public_events

      expect(events).to contain_exactly(
        external_id: "42",
        title: "Ruby Meetup",
        description: "Talks and pizza",
        starts_at: Time.zone.parse("2026-09-01T18:00:00Z"),
        image_url: "https://example.com/image.jpg",
        source_url: "https://billetto.com/events/42",
      )
    end

    it "raises a RequestError when the API responds with an error status" do
      stub_request(:get, "https://billetto.dk/api/v3/public/events")
        .with(query: { "limit" => "50" })
        .to_return(status: 500)

      expect { client.list_public_events }.to raise_error(Billetto::ResponseError)
    end

    it "raises a RequestError when the connection itself fails" do
      stub_request(:get, "https://billetto.dk/api/v3/public/events")
        .with(query: { "limit" => "50" })
        .to_timeout

      expect { client.list_public_events }.to raise_error(Billetto::RequestError)
    end

    it "raises a ResponseError when an event is missing a required field" do
      stub_request(:get, "https://billetto.dk/api/v3/public/events")
        .with(query: { "limit" => "50" })
        .to_return(
          status: 200,
          headers: { "Content-Type" => "application/json" },
          body: { events: [ { id: 1 } ] }.to_json
        )

      expect { client.list_public_events }.to raise_error(Billetto::ResponseError, /title/)
    end
  end
end
