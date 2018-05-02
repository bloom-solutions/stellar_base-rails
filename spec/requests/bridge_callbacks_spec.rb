require "spec_helper"

describe "POST /bridge_callbacks", type: :request do
  let(:uri) do
    StellarBase::Engine.routes.url_helpers.bridge_callbacks_path
  end

  context "successful callback class" do
    it "triggers the configured .on_bridge_callback class" do
      params = {
        id: "OPERATION_ID_1234",
        from: "GABCSENDERXLMADDRESS",
        route: "RECIPIENTROUTE",
        amount: 100.00,
        asset_code: "XLM",
        asset_issuer: "GABCASSETISSUER",
        memo_type: "id",
        memo: "2",
        data: "DATAHASH",
        transaction_id: "TRANSACTION_ID_1234",
      }

      post uri, params: params

      expect(response).to be_success
      expect(response.code.to_i).to eq 200
    end
  end


  context "failed callback class" do
    before do
      StellarBase.configure do |c|
        c.on_bridge_callback = "ProcessFailedBridgeCallback"
      end
    end

    after do
      StellarBase.configure do |c|
        c.on_bridge_callback = "ProcessBridgeCallback"
      end
    end

    it "triggers the configured .on_bridge_callback class" do
      params = {
        id: "OPERATION_ID_1234",
        from: "GABCSENDERXLMADDRESS",
        route: "RECIPIENTROUTE",
        amount: 100.00,
        asset_code: "XLM",
        asset_issuer: "GABCASSETISSUER",
        memo_type: "id",
        memo: "2",
        data: "DATAHASH",
        transaction_id: "TRANSACTION_ID_1234",
      }

      post uri, params: params

      expect(response.success?).to eq false
      expect(response.code.to_i).to eq 422
    end
  end
end
