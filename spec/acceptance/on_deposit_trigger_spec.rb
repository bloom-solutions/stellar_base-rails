require "spec_helper"

describe "StellarBase.on_deposit_trigger" do
  context "deposit_config not found" do
    it "skips remaining actions and fails" do
      result = StellarBase.on_deposit_trigger(
        network: "eth",
        deposit_address: "1bc",
        tx_id: "",
        amount: 0.5,
      )
      expect(result).to be_failure
      expect(result.message).to eq "No depositable_asset config for eth"
    end
  end

  context "deposit_request doesn't exist" do
    it "skips remaining actions" do
      result = StellarBase.on_deposit_trigger(
        network: "bitcoin",
        deposit_address: "1bc",
        tx_id: "",
        amount: 0.5,
      )
      expect(result).to be_skip_remaining
      expect(result.message).to eq "No DepositRequest found for BTCT:1bc"
    end
  end

  context "deposit_request exists, but has previous deposit" do
    let(:deposit_request) do
      create(:stellar_base_deposit_request, {
        asset_code: "BTCT",
        deposit_address: "1bc",
      })
    end
    let!(:deposit) do
      create(:stellar_base_deposit, {
        amount: 0.35,
        deposit_request: deposit_request,
        stellar_tx_id: "s12",
        tx_id: "def",
      })
    end

    it "skips remaining actions" do
      result = StellarBase.on_deposit_trigger(
        network: "bitcoin",
        deposit_address: "1bc",
        tx_id: "def",
        amount: 0.5,
      )

      expect(result).to be_skip_remaining
      expect(result.message).to eq "Deposit trigger previously made, skipping"
      expect(result.deposit.amount).to eq 0.35
      expect(result.deposit.stellar_tx_id).to eq "s12"
      expect(result.deposit.tx_id).to eq "def"
    end
  end

  context(
    "deposit_request exists, but has no previous deposit",
    vcr: { record: :once, match_requests_on: [:method] },
  ) do
    let!(:deposit_request) do
      create(:stellar_base_deposit_request, {
        asset_code: "BTCT",
        deposit_address: "1bc",
        account_id: recipient_account.address,
      })
    end
    let(:recipient_account) { Stellar::Account.random }
    let(:issuing_account) { Stellar::Account.from_seed(CONFIG[:issuer_seed]) }
    let(:distribution_account) { Stellar::Account.random }
    let(:client) { Stellar::Client.default_testnet }
    let(:asset) { Stellar::Asset.alphanum4("BTCT", issuing_account.keypair) }

    before do
      StellarBase.configuration.depositable_assets = [
        {
          type: "crypto",
          network: "bitcoin",
          asset_code: "BTCT",
          issuer: issuing_account.address,
          distributor: distribution_account.address,
          distributor_seed: distribution_account.keypair.seed,
          how_from: GetHow.to_s,
          max_amount_from: GetMaxAmount.to_s,
        },
      ]

      [distribution_account, recipient_account].each do |account|
        client.create_account(
          funder: issuing_account,
          account: account,
          starting_balance: 2,
        )

        client.change_trust(
          asset: [:alphanum4, "BTCT", issuing_account.keypair],
          source: account,
        )
      end

      amount = Stellar::Amount.new(3, asset)

      client.send_payment(
        from: issuing_account,
        to: distribution_account,
        amount: amount,
      )
    end

    it "creates the deposit and sends the stellar asset" do
      result = StellarBase.on_deposit_trigger(
        network: "bitcoin",
        deposit_address: "1bc",
        tx_id: "2cd",
        amount: 0.05,
      )

      expect(result).to be_success

      deposit = result.deposit

      expect(deposit).to be_present
      expect(deposit).to be_persisted
      expect(deposit.tx_id).to eq "2cd"
      expect(deposit.amount).to eq 0.05
      expect(deposit.stellar_tx_id).to be_present

      response = client.account_info(recipient_account)

      btct_balance = response.balances.find do |balance|
        balance["asset_code"] == "BTCT"
      end

      expect(btct_balance["balance"].to_f).to eq 0.05
    end
  end
end
