require "spec_helper"

describe "GET /balance", type: :request do
  let(:uri) do
    StellarBase::Engine.routes.url_helpers.balance_path(asset_code)
  end

  context "balance for an asset" do
    let(:asset_code) { "BTCT" }
    let(:json_response) do
      get(uri, params: { format: :json })

      expect(response).to be_successful
      JSON.parse(response.body).with_indifferent_access
    end

    it "executes the given instructions" do
      expect(json_response[:asset_code]).to eq "BTCT"
      expect(json_response[:amount]).to eq "1.0"
    end
  end

  context "requesting withdrawal details for an invalid asset" do
    let(:asset_code) { "BCHT" }

    it "returns an error" do
      get(uri, params: { format: :json })

      expect(response).not_to be_successful
      json = JSON.parse(response.body).with_indifferent_access

      expect(json["error"]).to be_present
      expect(json["error"]["asset_code"])
        .to include "invalid asset_code. Valid asset_codes: BTCT"
    end
  end

  context "requesting withdrawal details without the `withdraw` module" do
    let(:asset_code) { "BCHT" }

    before do
      StellarBase.configuration.modules = %w[bridge_callbacks]
    end

    it "denies access" do
      get(uri, params: { format: :json })

      expect(response).not_to be_successful
      json = JSON.parse(response.body).with_indifferent_access

      expect(json["error"]).to be_present
      expect(json["error"]).to eq "Not authorized to check balances"
    end
  end
end
