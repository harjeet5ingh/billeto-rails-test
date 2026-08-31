# Base class for our domain events (facts). Subclasses declare a SCHEMA of
# required data keys and a #stream_names method - the first stream is where
# the fact is actually published, the rest are just linked to it, so the
# same fact can show up in more than one stream's history.
class Fact < RubyEventStore::Event
  class InvalidData < StandardError; end

  def initialize(data:, **kwargs)
    self.class::SCHEMA.each_key do |key|
      raise InvalidData, "#{self.class} is missing #{key}" unless data.key?(key)
    end

    super(data: data, **kwargs)
  end

  def stream_names
    raise NotImplementedError, "#{self.class} must implement #stream_names"
  end

  def publish(event_store: Rails.configuration.event_store)
    primary_stream, *linked_streams = stream_names
    event_store.publish(self, stream_name: primary_stream)
    linked_streams.each { |stream_name| event_store.link(event_id, stream_name: stream_name) }
    self
  end
end
