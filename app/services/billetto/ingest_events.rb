module Billetto
  # Pulls events from the Billetto API (or its fake stand-in) and upserts
  # them into our Event table. Invalid records are skipped rather than
  # aborting the whole run, since one bad upstream record shouldn't stop us
  # from ingesting the rest.
  class IngestEvents
    Result = Struct.new(:created, :updated, :skipped, keyword_init: true)

    def initialize(client: Billetto.client)
      @client = client
    end

    def call
      counts = Hash.new(0)

      client.list_public_events.each do |attrs|
        event = Event.upsert_from_billetto(attrs)
        was_new_record = event.new_record?

        if event.save
          counts[was_new_record ? :created : :updated] += 1
        else
          counts[:skipped] += 1
        end
      end

      Result.new(created: counts[:created], updated: counts[:updated], skipped: counts[:skipped])
    end

    private

    attr_reader :client
  end
end
