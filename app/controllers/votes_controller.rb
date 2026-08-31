class VotesController < ApplicationController
  before_action :set_event

  def upvote
    Rails.configuration.command_bus.call(Voting::UpvoteEvent.new(event_id: @event.id, user_id: current_user_id))
    redirect_back fallback_location: events_path, notice: "Thanks for voting!"
  end

  def downvote
    Rails.configuration.command_bus.call(Voting::DownvoteEvent.new(event_id: @event.id, user_id: current_user_id))
    redirect_back fallback_location: events_path, notice: "Vote recorded."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end
