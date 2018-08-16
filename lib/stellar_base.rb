require "gem_config"
require "stellar-base"
require "light-service"
require "virtus"
require "httparty"
require "trailblazer-rails"
require "disposable"
require "reform"
require "reform/form/coercion"

require "stellar_base/engine"

module StellarBase
  include GemConfig::Base

  with_configuration do
    has :horizon_url, default: "https://horizon.stellar.org"
    has :modules, default: [:bridge_callbacks, :withdraw]
    has :withdraw
    has :on_bridge_callback
    has :check_bridge_callbacks_authenticity, default: false
    has :check_bridge_callbacks_mac_payload, default: false
    has :bridge_callbacks_mac_key, default: false
  end

  def self.included_module?(module_name)
    self.configuration.modules&.include?(module_name)
  end
end

require "stellar_base/horizon_client"
