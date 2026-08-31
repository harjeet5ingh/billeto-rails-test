# Sugar for declaring an async, event-store-subscribed ActiveJob handler in
# one line, e.g.:
#
#   class VoteCountProjector < ActiveJob::Base
#     include Handler.async(queue: :read_models)
#     subscribes_to EventUpvoted, EventDownvoted
#     def perform(event) = ...
#   end
#
# `subscribes_to` just records which facts this handler wants - actually
# wiring it up to the event store happens once, centrally, in
# config/initializers/domain.rb.
module Handler
  def self.async(queue:)
    Module.new do
      define_singleton_method(:included) do |host_class|
        host_class.prepend(RailsEventStore::AsyncHandler)
        host_class.queue_as(queue)

        host_class.define_singleton_method(:subscribes_to) do |*event_classes|
          @subscribed_to = event_classes.flatten
        end

        host_class.define_singleton_method(:subscribed_to) { @subscribed_to || [] }
        host_class.define_singleton_method(:subscriptions) { { self => subscribed_to } }
      end
    end
  end
end
