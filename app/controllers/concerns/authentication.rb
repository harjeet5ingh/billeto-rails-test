module Authentication
  extend ActiveSupport::Concern

  # Whether we're actually talking to real Clerk, or falling back to the
  # local fake sign-in flow - mirrors the CLERK_SKIP_RAILTIE guard in
  # config/application.rb, and is always false in tests.
  CLERK_ENABLED = ENV["CLERK_SECRET_KEY"].to_s.start_with?("sk_") && ENV["RAILS_ENV"] != "test"

  included do
    helper_method :current_user_id, :user_signed_in?
  end

  def current_user_id
    CLERK_ENABLED ? clerk&.user_id : session[:fake_user_id]
  end

  def user_signed_in?
    current_user_id.present?
  end

  def require_authentication!
    return if user_signed_in?

    redirect_to root_path, alert: "Please sign in to vote."
  end
end
