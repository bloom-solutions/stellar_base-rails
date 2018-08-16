require "spec_helper"

describe "GET /withdraw", type: :request, vcr: {record: :once} do
  let(:uri) do
    StellarBase::Engine.routes.url_helpers.withdraw_path
  end

  before do
    @withdraw_request = @bridge_callback = nil
    StellarBase.configuration.on_withdraw = ->(withdrawal_request, bridge_callback) do
      @withdrawal_request = withdrawal_request
      @bridge_callback = bridge_callback
    end
  end

  context "payment for an asset that can be withdrawn" do
    let(:bridge_callback) do
      build_stubbed(:stellar_base_bridge_callback, {
        amount: 0.5,
        asset_code: "BTCT",
        asset_issuer: CONFIG[:asset_address],
      })
    end

    it "executes the given class" do
      get(uri, {
        params: {
          type: "crypto",
          asset_code: "BTCT",
          dest: "my-btc-address",
          network_fee: 0.001,
        }
      })

      expect(response).to be_success
      json_response = JSON.parse(response.body).with_indifferent_access
      expect(response[:type]).to eq "crypto"
      expect(response[:asset_code]).to eq "BTCT"
      expect(response[:dest]).to eq "my-btc-address"
      expect(response[:fee_fixed]).to eq 0.01
      expect(response[:fee_percent]).to be_zero
      expect(response[:network_fee]).to eq 0.001
      expect(response[:memo_type]).to "text"
      expect(response[:memo]).to be_present

      expect(@withdrawal_request.account_id).
        to eq StellarBase.configuration.distribution_account
      expect(@withdrawal_request.asset_type).to eq "crypto"
      expect(@withdrawal_request.asset_code).to eq "BTCT"
      expect(@withdrawal_request.issuer).to eq CONFIG[:issuer_address]
      expect(@withdrawal_request.dest).to eq "my-btc-address"
      expect(@withdrawal_request.fee_fixed).to eq 0.01
      expect(@withdrawal_request.fee_percent).to be_zero
      expect(@withdrawal_request.network_fee).to eq 0.001
      expect(@withdrawal_request.memo_type).to "text"
      expect(@withdrawal_request.memo).to be_present

      expect(@bridge_callback).to eq bridge_callback
    end
  end

  context "payment for an asset that cannot be withdrawn" do
    it "does nothing" do
      expect(@withdrawal_request).to be false
      expect(@callback_called).to be false
    end
  end
end
