CONFIG = YAML.load_file(SPEC_DIR.join("config.yml")).with_indifferent_access
CONFIG[:issuer_account] = Stellar::Account.random

RSpec.configure do |c|

  c.before(:each) do
    StellarBase.configure do |c|
      c.modules = %i(bridge_callbacks)
      c.horizon_url = "https://horizon-testnet.stellar.org"

      c.distribution_account = "G-DISTRO-ACCOUNT"

      c.on_bridge_callback = "ProcessBridgeCallback"
      c.check_bridge_callbacks_authenticity = false
      c.check_bridge_callbacks_mac_payload = false
      c.bridge_callbacks_mac_key = "sample"

      c.withdraw = [
        {
          type: "crypto",
          network: "bitcoin",
          asset_code: "BTCT",
          issuer: CONFIG[:issuer_address],
          fee_fixed: 0.01,
        }
      ]
      c.on_withdraw = ProcessWithdrawal.to_s
    end
  end

end
