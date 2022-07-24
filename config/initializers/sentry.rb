Sentry.init do |config|
  config.dsn = 'https://0a271cb0ed0c412783864451a793ba44@o1316540.ingest.sentry.io/6569181'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  config.environment = Rails.env
  config.enabled_environments = ["production"]
end
