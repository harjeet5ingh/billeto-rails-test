class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user_id

  private

  # Placeholder identity until real authentication lands - every visitor
  # gets a stable per-session id so votes have someone to belong to.
  def current_user_id
    session[:anonymous_id] ||= SecureRandom.hex(8)
  end
end
