Rails.configuration.to_prepare do
  Rails.configuration.billetto_client ||= begin
    api_key = Rails.application.credentials.dig(:billetto, :api_key) || ENV["BILLETTO_API_KEY"]

    if api_key.present?
      Billetto::Client.new(
        base_url: Rails.application.credentials.dig(:billetto, :api_base) || ENV["BILLETTO_API_BASE"] || "https://billetto.dk/api/v3/",
        api_key: api_key
      )
    else
      # No credentials configured yet - fall back to canned sample data so the
      # app is fully runnable (and browsable) without a Billetto account.
      Billetto::FakeClient.new
    end
  end
end
