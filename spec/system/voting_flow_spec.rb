require "rails_helper"

RSpec.describe "Voting", type: :system do
  it "lets a signed-in visitor vote, then blocks voting again after signing out" do
    create(:event, title: "System Spec Meetup")

    visit root_path
    expect(page).to have_content("System Spec Meetup")
    expect(page).to have_link("Sign in")

    sign_in_via_browser_as("voter@example.com")
    expect(page).to have_content("Signed in as voter@example.com")

    click_button "▲ 0"
    expect(page).to have_button("▲ 1")

    click_button "Sign out"
    expect(page).to have_link("Sign in")
  end
end
