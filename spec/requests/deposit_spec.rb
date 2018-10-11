require "spec_helper"

describe "GET /deposit", type: :request, vcr: { record: :once } do
  let(:uri) { StellarBase::Engine.routes.url_helpers.deposit_path }

  context "requesting deposit details for valid asset" do
    let(:distributor_account) { Stellar::Account.random.keypair }
    let(:user_account) { Stellar::Account.random.address }
    let(:details) do
      StellarBase.configuration.depositable_assets.dup.find do |asset|
        asset[:asset_code] == "BTCT"
      end
    end

    before do
      StellarBase.configuration.depositable_assets = [
        type: "crypto",
        network: "bitcoin",
        asset_code: "BTCT",
        issuer: CONFIG[:issuer_address],
        distributor: distributor_account.address,
        distributor_seed: distributor_account.seed,
        how_from: GetHow.to_s,
        max_amount_from: GetMaxAmount.to_s,
      ]
    end

    context "valid params" do
      it "responds with deposit details" do
        get(uri, {
          params: {
            asset_code: "BTCT",
            account: user_account,
            format: :json,
          },
        })

        expect(response).to be_successful

        json = JSON.parse(response.body).with_indifferent_access

        expect(json[:how]).to eq GetHow::SAMPLE_BTC_ADDRESS
        expect(json[:max_amount].to_f).to eq GetMaxAmount::SAMPLE_MAX_AMOUNT
        expect(json[:eta]).to eq 600
        expect(json[:fee_fixed]).to eq "0.0"
        expect(json[:fee_percent]).to eq "0.0"
      end
    end

    context "invalid params" do
      it "responds with errors" do
        get(uri, params: { asset_code: "BTCT", format: :json })

        expect(response.status).to eq 422

        json = JSON.parse(response.body).with_indifferent_access

        expect(json[:error]).to include({ "account_id": ["can't be blank"]})
      end
    end
  end

  context "requesting deposit details for an invalid asset" do
    it "returns an error" do
      get(uri, {
        params: {
          asset_code: "BCHT",
          account: "GABC",
          format: :json,
        },
      })

      expect(response).not_to be_successful
      json = JSON.parse(response.body).with_indifferent_access

      expect(json["error"]).to be_present
      expect(json["error"]["asset_code"])
        .to include "invalid asset_code. Valid asset_codes: BTCT"
    end
  end
end
