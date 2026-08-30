namespace :billetto do
  desc "Fetch public events from Billetto and upsert them into the events table"
  task ingest_events: :environment do
    result = Billetto::IngestEvents.new.call
    puts "Billetto ingest done - created: #{result.created}, updated: #{result.updated}, skipped: #{result.skipped}"
  end
end
