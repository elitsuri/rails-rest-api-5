require_relative 'boot'
require 'rails/all'
Bundler.require(*Rails.groups)

module AppCore
  class Application < Rails::Application
    config.load_defaults 7.1
    config.api_only = true
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV.fetch('CORS_ORIGINS', '*')
        resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head], expose: ['Authorization']
      end
    end
    config.active_job.queue_adapter = :sidekiq
    config.time_zone = 'UTC'
  end
end
