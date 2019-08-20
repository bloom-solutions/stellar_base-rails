RSpec.configure do |c|
  c.before(:each) do
    StellarBase.configure do |c|
      c.bridge_callbacks_mac_key = "sample"
      c.check_bridge_callbacks_authenticity = false
      c.check_bridge_callbacks_mac_payload = false
      c.distribution_account = "G-DISTRO-ACCOUNT"
      c.horizon_url = "https://horizon-testnet.stellar.org"
      c.modules = %i[bridge_callbacks withdraw deposit balances fees]
      c.on_bridge_callback = "ProcessBridgeCallback"
      c.on_withdraw = ProcessWithdrawal.to_s
      c.stellar_toml = { TRANSFER_SERVER: "http://example.com/stellar" }
      c.stellar_network = "testnet"
      c.on_account_event = ->(address, tx, op) do
      end

      c.withdrawable_assets = [
        {
          type: "crypto",
          network: "bitcoin",
          asset_code: "BTCT",
          issuer: ENV["ISSUER_ADDRESS"],
          max_amount_from: GetMaxAmount,
          fee_fixed_quote_from: GetWithdrawFeeFixedQuoteFrom,
          fee_fixed_from: GetWithdrawFeeFixedFrom,
        },
      ]
      c.depositable_assets = [
        {
          type: "crypto",
          network: "bitcoin",
          asset_code: "BTCT",
          issuer: ENV["ISSUER_ADDRESS"],
          distributor: ENV["DISTRIBUTOR_ADDRESS"],
          distributor_seed: ENV["DISTRIBUTOR_SEED"],
          eta_from: GetEta,
          extra_info_from: GetDepositExtraInfo,
          how_from: GetHow,
          max_amount_from: GetMaxAmount,
        },
      ]
    end
  end
end
