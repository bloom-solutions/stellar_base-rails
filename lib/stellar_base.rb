require "gem_config"
require "light-service"
require "dry-struct"
require "trailblazer-rails"
require "disposable"
require "reform"
require "reform/form/coercion"
require "stellar_base/engine"

module StellarBase
  include GemConfig::Base

  with_configuration do
    has :modules, default: [:bridge_callbacks]
    has :check_bridge_callbacks_authenticity, default: false
    has :on_bridge_callback
  end

  def self.included_module?(module_name)
    self.configuration.modules&.include?(module_name)
  end
end


