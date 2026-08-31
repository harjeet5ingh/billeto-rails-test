require "rails_helper"

RSpec.describe Voting::VoteCountProjector do
  let(:event) { create(:event) }

  it "creates and increments the vote_counts row as upvotes and downvotes come in" do
    Rails.configuration.command_bus.call(Voting::UpvoteEvent.new(event_id: event.id, user_id: "user_1"))
    Rails.configuration.command_bus.call(Voting::UpvoteEvent.new(event_id: event.id, user_id: "user_2"))
    Rails.configuration.command_bus.call(Voting::DownvoteEvent.new(event_id: event.id, user_id: "user_3"))

    vote_count = Voting::VoteCount.find_by!(event_id: event.id)
    expect(vote_count.upvotes).to eq(2)
    expect(vote_count.downvotes).to eq(1)
  end

  describe "#perform" do
    it "is a genuine projection, not a query - it can be replayed from raw facts" do
      upvoted = Voting::EventUpvoted.new(data: { event_id: event.id, user_id: "user_1", voted_at: Time.current })
      downvoted = Voting::EventDownvoted.new(data: { event_id: event.id, user_id: "user_2", voted_at: Time.current })

      described_class.new.perform(upvoted)
      described_class.new.perform(upvoted)
      described_class.new.perform(downvoted)

      vote_count = Voting::VoteCount.find_by!(event_id: event.id)
      expect(vote_count.upvotes).to eq(2)
      expect(vote_count.downvotes).to eq(1)
    end
  end
end
