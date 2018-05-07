require "spec_helper"

module StellarBase
  module BridgeCallbacks
    RSpec.describe VerifyMacPayload do

      before do
        StellarBase.configure do |c|
          c.check_bridge_callbacks_mac_payload = true
          c.bridge_callbacks_mac_key = "TEST"
        end
      end

      after do
        StellarBase.configure do |c|
          c.check_bridge_callbacks_mac_payload = false
          c.bridge_callbacks_mac_key = "TEST"
        end
      end

      let(:callback_params) do
        {
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
      end
      let(:callback_mac_payload) do
        payload = OpenSSL::HMAC.digest(
          "SHA256",
          mac_key,
          callback_params.to_json,
        )
        Base64.encode64(payload)
      end

      context "doesn't match" do
        let(:mac_key) { "1234" }

        it "returns false" do
          result = described_class.execute(
            callback_params: callback_params,
            callback_mac_payload: callback_mac_payload,
          )

          expect(result).to be_failure

          message = "X_PAYLOAD_MAC and encoded raw request body doesn't match"
          expect(result.message).to eq message
        end
      end

      context "it matches" do
        let(:mac_key) { StellarBase.configuration.bridge_callbacks_mac_key }

        it "returns true" do
          result = described_class.execute(
            callback_params: callback_params,
            callback_mac_payload: callback_mac_payload,
          )

          expect(result).to be_success
        end
      end

      context "no callback_mac_payload given" do
        it "returns false" do
          result = described_class.execute(
            callback_params: callback_params,
            callback_mac_payload: "",
          )

          expect(result).to be_failure
          expect(result.message).to eq "X_PAYLOAD_MAC not present"
        end

      end
    end
  end
end
