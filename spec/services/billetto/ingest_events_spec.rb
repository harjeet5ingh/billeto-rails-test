require "rails_helper"

RSpec.describe Billetto::IngestEvents do
  let(:valid_attrs) do
    { external_id: "billetto-1", title: "Ruby Meetup", description: "Talks and pizza",
      starts_at: 1.week.from_now, image_url: nil, source_url: nil }
  end
  let(:invalid_attrs) do
    { external_id: "billetto-2", title: nil, description: nil,
      starts_at: 1.week.from_now, image_url: nil, source_url: nil }
  end
  let(:client) { instance_double(Billetto::Client, list_public_events: [valid_attrs, invalid_attrs]) }

  subject(:ingest) { described_class.new(client: client) }

  it "creates valid events and skips invalid ones instead of aborting" do
    result = ingest.call

    expect(result.created).to eq(1)
    expect(result.skipped).to eq(1)
    expect(Event.find_by(external_id: "billetto-1")).to be_present
    expect(Event.find_by(external_id: "billetto-2")).to be_nil
  end

  it "updates an already-ingested event instead of creating a duplicate" do
    create(:event, external_id: "billetto-1", title: "Old title")

    result = ingest.call

    expect(result.created).to eq(0)
    expect(result.updated).to eq(1)
    expect(Event.find_by(external_id: "billetto-1").title).to eq("Ruby Meetup")
  end
end
