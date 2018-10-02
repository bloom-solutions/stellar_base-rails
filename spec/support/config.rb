CONFIG = YAML.load_file(SPEC_DIR.join("config.yml")).with_indifferent_access
CONFIG[:issuer_address] = Stellar::Account.random.address
CONFIG[:distributor] = Stellar::Account.random

RSpec.configure do |c|
  c.before(:each) do
    StellarBase.configure do |c|
      c.bridge_callbacks_mac_key = "sample"
      c.check_bridge_callbacks_authenticity = false
      c.check_bridge_callbacks_mac_payload = false
      c.distribution_account = "G-DISTRO-ACCOUNT"
      c.horizon_url = "https://horizon-testnet.stellar.org"
      c.modules = %i[bridge_callbacks withdraw deposit]
      c.on_bridge_callback = "ProcessBridgeCallback"
      c.on_withdraw = ProcessWithdrawal.to_s
      c.stellar_toml = { TRANSFER_SERVER: "http://example.com/stellar" }

      c.withdrawable_assets = [
        {
          type: "crypto",
          network: "bitcoin",
          asset_code: "BTCT",
          issuer: CONFIG[:issuer_address],
          fee_fixed: 0.01,
          max_amount_from: GetMaxAmount.to_s,
        },
      ]
      c.depositable_assets = [
        {
          type: "crypto",
          network: "bitcoin",
          asset_code: "BTCT",
          issuer: CONFIG[:issuer_address],
          distributor: CONFIG[:distributor].address,
          distributor_seed: CONFIG[:distributor].keypair.seed,
          how_from: GetHow.to_s,
          max_amount_from: GetMaxAmount.to_s,
        },
      ]
    end
  end
end
