module Billetto
  # Thin adapter around the Billetto public events API
  # (https://api.billetto.com/reference/list-public-events). Keeps Faraday
  # and the raw JSON shape out of the rest of the app - callers only ever
  # see normalized hashes or a Billetto::Error subclass.
  class Client
    def initialize(base_url:, api_key:)
      @base_url = base_url
      @api_key = api_key
    end

    def list_public_events(limit: 50)
      response = connection.get("public/events", limit: limit)

      unless response.success?
        raise ResponseError, "Billetto API returned #{response.status}"
      end

      normalize_events(response.body)
    rescue Faraday::Error => e
      raise RequestError, "Billetto API request failed: #{e.message}"
    end

    private

    attr_reader :base_url, :api_key

    def connection
      @connection ||= Faraday.new(url: base_url) do |conn|
        conn.headers["Api-Keypair"] = api_key
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.options.open_timeout = 5
        conn.options.timeout = 10
      end
    end

    def normalize_events(body)
      raw_events = body.is_a?(Hash) ? (body["events"] || body["data"]) : body
      raise ResponseError, "Billetto API response was not a list of events" unless raw_events.is_a?(Array)

      raw_events.map { |raw_event| normalize(raw_event) }
    end

    def normalize(raw_event)
      {
        external_id: raw_event.fetch("id").to_s,
        title: raw_event.fetch("title"),
        description: raw_event["description"],
        starts_at: parse_time(raw_event["startdate"]),
        image_url: raw_event["image_link"],
        source_url: raw_event["url"]
      }
    rescue KeyError => e
      raise ResponseError, "Billetto event is missing #{e.key}"
    end

    def parse_time(value)
      Time.zone.parse(value) if value.present?
    end
  end
end
