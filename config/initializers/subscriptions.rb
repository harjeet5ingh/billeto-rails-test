# Wires up every domain module's async handlers to the event store. Needs to
# run after config/initializers/rails_event_store.rb sets up the client -
# alphabetically "subscriptions.rb" sorts after "rails_event_store.rb", so
# to_prepare callbacks run in the right order.
Rails.application.config.to_prepare do
  Voting.subscriptions.each do |handler, event_classes|
    Rails.configuration.event_store.subscribe(handler, to: event_classes)
  end
end
