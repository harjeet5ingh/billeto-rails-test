module FakeAuthentication
  # Request specs: posts to the fake sign-in form, same as a real visitor.
  def sign_in_as(email)
    post fake_session_path, params: { email: email }
  end

  # System specs: drives the fake sign-in form through the browser.
  def sign_in_via_browser_as(email)
    visit new_fake_session_path
    fill_in "Email", with: email
    click_button "Sign in"
  end
end

RSpec.configure do |config|
  config.include FakeAuthentication, type: :request
  config.include FakeAuthentication, type: :system
end
