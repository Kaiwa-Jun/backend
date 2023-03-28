require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application

    config.load_defaults 6.1

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.api_only = true
    config.autoload_paths += %W(#{config.root}/lib)
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:3001', '127.0.0.1:3001'

        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          expose: %w(access-token expiry token-type uid client),
          max_age: 0
      end
    end
  end
end
