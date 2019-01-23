# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TaskWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
    config.generators do |g|
      g.javascripts false
      g.test_framework :rspec,
                       controller_specs: true,
                       helper_specs: false,
                       model_specs: true,
                       request_specs: false,
                       routing_specs: false,
                       view_specs: false
    end
    config.action_view.field_error_proc = proc { |html_tag, instance| html_tag }
  end
end
