# Stands in for Clerk's hosted sign-in/sign-up UI when no real Clerk
# credentials are configured (see Authentication::CLERK_ENABLED), so voting
# and its auth restriction are fully exercisable in dev and specs.
class FakeSessionsController < ApplicationController
  def new
  end

  def create
    session[:fake_user_id] = params.require(:email).presence
    redirect_to events_path, notice: "Signed in as #{session[:fake_user_id]}."
  end

  def destroy
    session.delete(:fake_user_id)
    redirect_to events_path, notice: "Signed out."
  end
end
