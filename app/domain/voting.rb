module Voting
  def self.subscriptions
    [ VoteCountProjector ].map(&:subscriptions).reduce(&:merge)
  end
end
