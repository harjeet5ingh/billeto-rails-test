Rails.configuration.to_prepare do
  Rails.configuration.billetto_client ||= Billetto::Client.new(
    base_url: Rails.application.credentials.dig(:billetto, :api_base) || ENV["BILLETTO_API_BASE"] || "https://billetto.dk/api/v3/",
    api_key: Rails.application.credentials.dig(:billetto, :api_key) || ENV["BILLETTO_API_KEY"]
  )
end
