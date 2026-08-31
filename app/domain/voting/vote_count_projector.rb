module Voting
  class VoteCountProjector < ActiveJob::Base
    include Handler.async(queue: :read_models)
    subscribes_to EventUpvoted, EventDownvoted

    def perform(event)
      vote_count = VoteCount.find_or_create_by!(event_id: event.data.fetch(:event_id))

      case event
      when EventUpvoted then vote_count.increment!(:upvotes)
      when EventDownvoted then vote_count.increment!(:downvotes)
      end
    end
  end
end
