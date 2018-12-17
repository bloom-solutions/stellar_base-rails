require "addressable"
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
require "sidekiq"
require "sidekiq-unique-jobs"
require "storext"

require "stellar_base/engine"

module StellarBase
  include GemConfig::Base

  with_configuration do
    has :bridge_callbacks_mac_key, default: false
    has :check_bridge_callbacks_authenticity, default: false
    has :check_bridge_callbacks_mac_payload, default: false
    has :distribution_account, classes: [NilClass, String]
    has :horizon_url, default: "https://horizon.stellar.org"
    has :modules, default: [:bridge_callbacks]
    has :on_bridge_callback
    has :on_withdraw
    has :on_account_event
    has :subscribe_to_accounts, classes: [Array], default: []
    has :stellar_network, classes: String, default: "testnet"
    has :stellar_toml, classes: Hash, default: {}
    has :depositable_assets, classes: [NilClass, Array, String, Pathname]
    has :withdrawable_assets, classes: [NilClass, Array, String, Pathname]
    has :sending_strategy, classes: [Array, Symbol], default: [:stellar_sdk]
  end

  after_configuration_change do
    convert_config_withdraw!
    convert_config_deposit!
    set_stellar_network!
    configure_sidekiq_death_handler!
    configure_sending_strategy!
  end

  def self.on_deposit_trigger(network:, deposit_address:, tx_id:, amount:)
    DepositRequests::Trigger.(network, deposit_address, tx_id, amount)
  end

  def self.included_module?(module_name)
    configuration.modules&.include?(module_name)
  end

  def self.set_stellar_network!
    stellar_network = configuration.stellar_network

    case stellar_network
    when "public"
      Stellar.default_network = Stellar::Networks::PUBLIC
    when "testnet"
      Stellar.default_network = Stellar::Networks::TESTNET
    else
      raise(
        ArgumentError,
        "'#{stellar_network}' not a valid stellar_network config",
      )
    end
  end

  def self.convert_config_deposit!
    depositable_assets = configuration.depositable_assets
    return if depositable_assets.is_a?(Array) || depositable_assets.nil?

    configuration.depositable_assets =
      convert_config!(depositable_assets)
  end

  def self.convert_config_withdraw!
    withdrawable_assets = configuration.withdrawable_assets
    return if withdrawable_assets.is_a?(Array) || withdrawable_assets.nil?

    configuration.withdrawable_assets =
      convert_config!(withdrawable_assets)
  end

  def self.configure_sending_strategy!
    sending_strategy = self.configuration.sending_strategy
    return if !sending_strategy.is_a?(Symbol)
    self.configuration.sending_strategy = Array(sending_strategy)
  end

  def self.convert_config!(asset_config)
    array_of_hashes = try_from_yaml_file_path(asset_config) ||
      try_from_json(asset_config)

    array_of_hashes.map(&:with_indifferent_access)
  end
  private_class_method :convert_config!

  def self.try_from_json(str)
    JSON.parse(str)
  rescue JSON::ParserError
  end
  private_class_method :try_from_json

  def self.try_from_yaml_file_path(str)
    YAML.load_file(str.to_s)
  rescue Errno::ENOENT
  end
  private_class_method :try_from_yaml_file_path

  def self.configure_sidekiq_death_handler!
    Sidekiq.configure_server do |config|
      config.death_handlers << ->(job, _ex) do
        return unless job['unique_digest']
        SidekiqUniqueJobs::Digests.del(digest: job['unique_digest'])
      end
    end
  end
end

require "stellar_base/horizon_client"
require "stellar_base/rails/routes"
