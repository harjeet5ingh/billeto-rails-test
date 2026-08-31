require "rails_helper"

RSpec.describe Voting::UpvoteEvent do
  let(:event) { create(:event) }

  it "is invalid without an event_id or user_id" do
    expect(described_class.new).not_to be_valid
  end

  it "publishes an EventUpvoted fact with the event and user ids" do
    command = described_class.new(event_id: event.id, user_id: "user_1")

    expect { command.call }.to publish(
      an_event(Voting::EventUpvoted).with_data(event_id: event.id, user_id: "user_1")
    ).in(Rails.configuration.event_store)
  end

  it "links the fact into both the event's and the user's streams" do
    described_class.new(event_id: event.id, user_id: "user_1").call

    expect(Rails.configuration.event_store.read.stream("Voting::Event$#{event.id}").to_a.size).to eq(1)
    expect(Rails.configuration.event_store.read.stream("Voting::User$user_1").to_a.size).to eq(1)
  end
end
