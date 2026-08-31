require "rails_helper"

RSpec.describe "Votes", type: :request do
  let(:event) { create(:event) }

  describe "when signed out" do
    it "redirects instead of recording an upvote" do
      post upvote_event_path(event)

      expect(response).to redirect_to(root_path)
      expect(Voting::VoteCount.find_by(event_id: event.id)).to be_nil
    end

    it "redirects instead of recording a downvote" do
      post downvote_event_path(event)

      expect(response).to redirect_to(root_path)
      expect(Voting::VoteCount.find_by(event_id: event.id)).to be_nil
    end
  end

  describe "when signed in" do
    before { sign_in_as("voter@example.com") }

    it "records an upvote and increments the count shown on the listing page" do
      post upvote_event_path(event)

      expect(response).to redirect_to(events_path)
      expect(Voting::VoteCount.find_by(event_id: event.id).upvotes).to eq(1)
    end

    it "records a downvote and increments the count shown on the listing page" do
      post downvote_event_path(event)

      expect(response).to redirect_to(events_path)
      expect(Voting::VoteCount.find_by(event_id: event.id).downvotes).to eq(1)
    end
  end
end
