require "rails_helper"

RSpec.describe "FakeSessions", type: :request do
  it "signs a visitor in and back out" do
    post fake_session_path, params: { email: "voter@example.com" }
    expect(response).to redirect_to(events_path)

    delete fake_session_path
    expect(response).to redirect_to(events_path)

    event = create(:event)
    post upvote_event_path(event)
    expect(response).to redirect_to(root_path) # signed out again, so voting is blocked
  end
end
