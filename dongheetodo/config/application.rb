require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dongheetodo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    config.i18n.available_locales = [:en, :ja]
    config.i18n.default_locale = :ja
    #
    # タイムゾーンを日本標準時に設定する
    #
    config.time_zone = "Asia/Tokyo"

    #
    # データベースTimeZoneは必ず:utcか:localを指定する
    #
    # :utc   = UTCタイムゾーンにする
    # :local = OSのタイムゾーンに従う
    config.active_record.default_timezone = :local
  end
end
