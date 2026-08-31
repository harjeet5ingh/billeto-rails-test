module Voting
  class DownvoteEvent
    include Command::Executable

    attribute :event_id
    attribute :user_id

    validates :event_id, :user_id, presence: true

    def call
      EventDownvoted.new(data: { event_id: event_id.to_i, user_id: user_id, voted_at: Time.current }).publish
    end
  end
end
