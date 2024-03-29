require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tsr2
  class Application < Rails::Application
    Dir[Rails.root.join('lib', 'middleware', '*.{rb}')].each { |file| require file }
    config.middleware.insert_before Rack::Runtime, MultipartBufferSetter
    
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.time_zone = 'Madrid'
    
    config.action_mailer.asset_host = 'http://www.thespainreport.es'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
  end
end