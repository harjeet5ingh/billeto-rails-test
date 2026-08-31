require "rails_helper"

RSpec.describe Voting::DownvoteEvent do
  let(:event) { create(:event) }

  it "is invalid without an event_id or user_id" do
    expect(described_class.new).not_to be_valid
  end

  it "publishes an EventDownvoted fact with the event and user ids" do
    command = described_class.new(event_id: event.id, user_id: "user_1")

    expect { command.call }.to publish(
      an_event(Voting::EventDownvoted).with_data(event_id: event.id, user_id: "user_1")
    ).in(Rails.configuration.event_store)
  end
end
