require "spec_helper"

describe "GET /fee", type: :request do
  let(:uri) do
    StellarBase::Engine.routes.url_helpers.fee_path(
      asset_code: asset_code,
      operation: operation,
      amount: 0.001,
      type: "crypto",
    )
  end

  context "fee_request for an depositable asset" do
    before do
      StellarBase.configuration.depositable_assets = [
        {
          type: "crypto",
          network: "bitcoin",
          asset_code: "BTCT",
          issuer: ENV["ISSUER_ADDRESS"],
          distributor: ENV["DISTRIBUTOR_ADDRESS"],
          distributor_seed: ENV["DISTRIBUTOR_SEED"],
          how_from: GetHow.to_s,
          max_amount_from: GetMaxAmount.to_s,
        },
      ]
    end
    let(:asset_code) { "BTCT" }
    let(:operation) { "deposit" }

    it "returns 0.0 since it's not configured" do
      get(uri, params: { format: :json })

      expect(response).to be_successful
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:fee]).to eq "0.0"
    end
  end

  context "fee_request for an withdrawable asset" do
    before do
      StellarBase.configuration.withdrawable_assets = [
        {
          type: "crypto",
          network: "bitcoin",
          asset_code: "BTCT",
          issuer: ENV["ISSUER_ADDRESS"],
          max_amount_from: GetMaxAmount.to_s,
          fee_from: GetWithdrawFeeFrom,
        },
      ]
    end
    let(:asset_code) { "BTCT" }
    let(:operation) { "withdraw" }

    it "returns 0.0 since it's not configured" do
      get(uri, params: { format: :json })

      expect(response).to be_successful
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:fee]).to eq "0.0001"
    end
  end

  context "requesting fee details for an invalid asset" do
    let(:asset_code) { "BCHT" }
    let(:operation) { "withdraw" }

    it "returns an error" do
      get(uri, params: { format: :json })

      expect(response).not_to be_successful
      json = JSON.parse(response.body).with_indifferent_access

      expect(json["error"]).to be_present
      expect(json["error"]["asset_code"])
        .to include "invalid asset_code. Valid asset_codes: BTCT"
    end
  end

  context "requesting fee details for an invalid operation" do
    let(:asset_code) { "BCHT" }
    let(:operation) { "depositz" }

    it "returns an error" do
      get(uri, params: { format: :json })

      expect(response).not_to be_successful
      json = JSON.parse(response.body).with_indifferent_access

      expect(json["error"]).to be_present
      expect(json["error"]["operation"])
        .to include "depositz is not a valid operation"
    end
  end

  context "requesting fee details without the `withdraw` module" do
    let(:asset_code) { "BCHT" }
    let(:operation) { "withdraw" }

    before do
      StellarBase.configuration.modules = %w[bridge_callbacks]
    end

    it "denies access" do
      get(uri, params: { format: :json })

      expect(response).not_to be_successful
      json = JSON.parse(response.body).with_indifferent_access

      expect(json["error"]).to be_present
      expect(json["error"]).to eq "You are unauthorized to request fee details"
    end
  end
end
