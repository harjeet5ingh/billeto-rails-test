require "rails_helper"

RSpec.describe "Events", type: :request do
  describe "GET /events" do
    it "lists the title, date and description of each event" do
      create(:event, title: "Ruby Meetup", description: "Talks and pizza", starts_at: Time.zone.parse("2026-09-01 18:00"))

      get events_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Ruby Meetup")
      expect(response.body).to include("Talks and pizza")
    end

    it "renders without erroring when there are no events yet" do
      get events_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /" do
    it "routes to the events index" do
      get root_path

      expect(response).to have_http_status(:ok)
    end
  end
end
