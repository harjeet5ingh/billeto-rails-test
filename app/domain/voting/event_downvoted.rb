module Voting
  class EventDownvoted < Fact
    SCHEMA = { event_id: Integer, user_id: String, voted_at: Time }.freeze

    def stream_names
      [ "Voting::Event$#{data.fetch(:event_id)}", "Voting::User$#{data.fetch(:user_id)}" ]
    end
  end
end
