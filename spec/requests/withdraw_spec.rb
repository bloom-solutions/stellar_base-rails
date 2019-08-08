require "spec_helper"

describe "GET /withdraw", type: :request, vcr: { record: :once } do
  let(:uri) do
    StellarBase::Engine.routes.url_helpers.withdraw_path
  end

  before do
    @withdraw_request = @stellar_operation = nil

    StellarBase.configuration.on_withdraw =
      -> (withdrawal_request, stellar_operation) do
        @withdrawal_request = withdrawal_request
        @stellar_operation = stellar_operation
      end

    StellarBase.configuration.withdrawable_assets = [
      {
        type: "crypto",
        network: "bitcoin",
        asset_code: "BTCT",
        issuer: ENV["ISSUER_ADDRESS"],
        max_amount_from: GetMaxAmount.to_s,
        fee_fixed_quote_from: GetWithdrawFeeFixedQuoteFrom,
        fee_fixed_from: ->(params, asset_details) do
          JSON.parse(params[:dest_extra]).
            with_indifferent_access[:fee_fixed]
        end,
      },
    ]
  end

  context "payment for an asset that can be withdrawn" do
    let(:stellar_transaction) do
      build_stubbed(:stellar_base_stellar_transaction, {
        memo_type: json_response[:memo_type],
        memo: json_response[:memo],
      })
    end
    let(:stellar_operation) do
      build_stubbed(:stellar_base_stellar_payment, {
        amount: 0.5,
        asset_code: "BTCT",
        asset_issuer: ENV["ISSUER_ADDRESS"],
        stellar_transaction: stellar_transaction,
      })
    end
    let(:json_response) do
      get(uri, {
        params: {
          type: "crypto",
          asset_code: "BTCT",
          dest: "my-btc-address",
          dest_extra: {fee_fixed: 0.123}.to_json,
          format: :json,
        },
      })

      expect(response).to be_successful
      JSON.parse(response.body).with_indifferent_access
    end

    it "executes the given instructions" do
      # NOTE: see WithdrawalRequestRepresenter spec for detailed specs
      expect(json_response[:account_id])
        .to eq StellarBase.configuration.distribution_account
      expect(json_response[:memo]).to be_present

      # Execute bridge callback
      StellarBase::WithdrawalRequests::Process.(stellar_operation)

      expect(@withdrawal_request).to be_present
      expect(@withdrawal_request.account_id)
        .to eq StellarBase.configuration.distribution_account
      expect(@withdrawal_request.asset_type).to eq "crypto"
      expect(@withdrawal_request.asset_code).to eq "BTCT"
      expect(@withdrawal_request.issuer).to eq ENV["ISSUER_ADDRESS"]
      expect(@withdrawal_request.dest).to eq "my-btc-address"
      expect(@withdrawal_request.fee_fixed).to eq 0.123
      expect(@withdrawal_request.fee_percent).to be_zero
      expect(@withdrawal_request.memo_type).to eq "text"
      expect(@withdrawal_request.memo).to be_present
      expect(@withdrawal_request.max_amount).to eq 1

      expect(@stellar_operation).to eq stellar_operation
    end
  end

  context "requesting withdrawal details for an invalid asset" do
    it "returns an error" do
      get(uri, {
        params: {
          type: "crypto",
          asset_code: "BCHT",
          dest: "my-bcht-address",
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

  context "payment for an asset that cannot be withdrawn" do
    it "does nothing" do
      expect(@withdrawal_request).to be_nil
      expect(@callback_called).to be_nil
    end
  end

  context "requesting withdrawal details without the `withdraw` module" do
    before do
      StellarBase.configuration.modules = %w[bridge_callbacks]
    end

    it "denies access" do
      get(uri, {
        params: {
          type: "crypto",
          asset_code: "BTCT",
          dest: "my-btc-address",
          format: :json,
        },
      })

      json = JSON.parse(response.body).with_indifferent_access

      expect(response).to_not be_success
      expect(json["error"]).to_not be_empty
    end
  end
end
