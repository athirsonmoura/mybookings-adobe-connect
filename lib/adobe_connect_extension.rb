require 'adobe_connect_extension/engine'
require 'adobe_connect'

# require 'active_support/dependencies'
# ActiveSupport::Dependencies.autoload_paths += [File.expand_path("..", __FILE__)]

module ResourceTypesExtensions
  module AdobeConnectExtension

    # include ActiveSupport::Dependencies
    # unloadable if Rails.env.development?

    autoload :AdobeConnectSingleton, 'adobe_connect_singleton'
    autoload :AdobeConnectAPIHelpers, 'adobe_connect_api_helpers'
    autoload :Extension, 'adobe_connect_extension/extension'

  end
end
