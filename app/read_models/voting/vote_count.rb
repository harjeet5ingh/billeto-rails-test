module Voting
  # A read model, not the source of truth - upvotes/downvotes are maintained
  # by VoteCountProjector as it replays EventUpvoted/EventDownvoted facts, and
  # can always be thrown away and rebuilt with `rails read_models:rebuild_vote_counts`.
  class VoteCount < ApplicationRecord
    belongs_to :event, inverse_of: :vote_count
  end
end
