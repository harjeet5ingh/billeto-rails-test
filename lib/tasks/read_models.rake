namespace :read_models do
  desc "Rebuild the vote_counts read model by replaying EventUpvoted/EventDownvoted facts"
  task rebuild_vote_counts: :environment do
    Voting::VoteCount.delete_all

    projector = Voting::VoteCountProjector.new
    event_types = [Voting::EventUpvoted, Voting::EventDownvoted]

    Rails.configuration.event_store.read.of_type(event_types).each do |event|
      projector.perform(event)
    end

    puts "Rebuilt vote_counts for #{Voting::VoteCount.count} event(s)."
  end
end
