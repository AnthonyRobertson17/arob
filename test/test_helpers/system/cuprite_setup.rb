# frozen_string_literal:true

# First, load Cuprite Capybara integration
require "capybara/cuprite"

# Then, we need to register our driver to be able to use it later
# with #driven_by method.
Capybara.register_driver(:custom) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1200, 1800],
    # See additional options for Dockerized environment in the respective section of this article
    browser_options: {},
    # Increase Chrome startup wait time (required for stable CI builds)
    process_timeout: 30,
    # Enable debugging capabilities
    inspector: true,
    # Allow running Chrome in a headful mode by setting HEADLESS env
    # var to a falsey value
    headless: !ENV["HEADLESS"].in?(["n", "0", "no", "false"]),
  )
end

# Configure Capybara to use :cuprite driver by default
Capybara.default_driver = Capybara.javascript_driver = :cuprite
