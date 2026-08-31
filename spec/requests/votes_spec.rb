require "rails_helper"

RSpec.describe "Votes", type: :request do
  let(:event) { create(:event) }

  describe "POST /events/:id/upvote" do
    it "records an upvote and increments the count shown on the listing page" do
      post upvote_event_path(event)

      expect(response).to redirect_to(events_path)
      expect(Voting::VoteCount.find_by(event_id: event.id).upvotes).to eq(1)
    end
  end

  describe "POST /events/:id/downvote" do
    it "records a downvote and increments the count shown on the listing page" do
      post downvote_event_path(event)

      expect(response).to redirect_to(events_path)
      expect(Voting::VoteCount.find_by(event_id: event.id).downvotes).to eq(1)
    end
  end
end
