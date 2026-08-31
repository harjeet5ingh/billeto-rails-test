require "capybara/cuprite"

Capybara.default_max_wait_time = 5
Capybara.javascript_driver = :cuprite
Capybara.default_driver = :cuprite

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1200, 800],
    process_timeout: 15,
    headless: !ENV["HEADLESS"].in?(%w[0 false])
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) { driven_by(:cuprite) }
end
