require "gem_config"
require "stellar-base"
require "light-service"
require "virtus"
require "httparty"
require "trailblazer-rails"
require "disposable"
require "multi_json"
require "reform"
require "reform/form/coercion"
require "representable"
require "toml-rb"

require "stellar_base/engine"

module StellarBase
  include GemConfig::Base

  with_configuration do
    has :horizon_url, default: "https://horizon.stellar.org"
    has :modules, default: [:bridge_callbacks]

    has :distribution_account, classes: [NilClass, String]

    has :on_bridge_callback
    has :check_bridge_callbacks_authenticity, default: false
    has :check_bridge_callbacks_mac_payload, default: false
    has :bridge_callbacks_mac_key, default: false

    has :withdrawable_assets, classes: [NilClass, Array, String, Pathname]
    has :on_withdraw

    has :depositable_assets, classes: [NilClass, Array, String, Pathname]

    has :stellar_toml, classes: Hash, default: {}
  end

  after_configuration_change do
    self.convert_config_withdraw!
    self.convert_config_deposit!
  end


  def self.included_module?(module_name)
    self.configuration.modules&.include?(module_name)
  end

  def self.convert_config_deposit!
    depositable_assets = self.configuration.depositable_assets
    return if depositable_assets.is_a?(Array) || depositable_assets.nil?

    self.configuration.depositable_assets =
      convert_config!(depositable_assets)
  end

  def self.convert_config_withdraw!
    withdrawable_assets = self.configuration.withdrawable_assets
    return if withdrawable_assets.is_a?(Array) || withdrawable_assets.nil?

    self.configuration.withdrawable_assets =
      convert_config!(withdrawable_assets)
  end

  private

  def self.convert_config!(asset_config)
    array_of_hashes = try_from_yaml_file_path(asset_config) ||
      try_from_json(asset_config)

    array_of_hashes.map(&:with_indifferent_access)
  end

  def self.try_from_json(str)
    JSON.parse(str)
  rescue JSON::ParserError
  end

  def self.try_from_yaml_file_path(str)
    YAML.load_file(str.to_s)
  rescue Errno::ENOENT
  end
end

require "stellar_base/horizon_client"
require "stellar_base/rails/routes"
