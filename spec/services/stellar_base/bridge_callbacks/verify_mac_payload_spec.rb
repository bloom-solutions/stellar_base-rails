require "spec_helper"

module StellarBase
  module BridgeCallbacks
    RSpec.describe VerifyMacPayload do

      it "calls a series of actions" do
        actions = [
          MacPayloads::CheckPayload,
          MacPayloads::DecodePayload,
          MacPayloads::DecodeMacKey,
          MacPayloads::EncodeParams,
          MacPayloads::Compare
        ]

        ctx = LightService::Context.new(
          callback_mac_payload: "TEST",
          callback_params: "TEST",
        )

        actions.each do |action|
          expect(action).to receive(:execute).with(ctx).and_return(ctx)
        end

        described_class.(callback_mac_payload: "TEST", callback_params: "TEST")
      end


      before do
        StellarBase.configure do |c|
          c.check_bridge_callbacks_mac_payload = true
          c.bridge_callbacks_mac_key = "SCGXDVN7C6M7SVLBICB4DBBMHD4VE3NUAQQYTZIGWZPOBC36JY3M4TKF"
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
          decoded_mac_key,
          callback_params.to_query,
        )
        Base64.encode64(payload)
      end
      let(:decoded_mac_key) do
        Stellar::Util::StrKey.check_decode(:seed, mac_key)
      end

      context "doesn't match" do
        let(:mac_key) { "SDYOGCQL6HLTPZUDYDH7E3YST2AGZR3PJZXED62N42FJA6AWXDP3FSCA" }

        it "returns false" do
          result = described_class.(
            callback_params: callback_params,
            callback_mac_payload: callback_mac_payload,
          )

          expect(result).to be_failure

          message = "HTTP_X_PAYLOAD_MAC and encoded raw POST doesn't match"
          expect(result.message).to eq message
        end
      end

      context "it matches" do
        let(:mac_key) { StellarBase.configuration.bridge_callbacks_mac_key }

        it "returns true" do
          result = described_class.(
            callback_params: callback_params,
            callback_mac_payload: callback_mac_payload,
          )

          expect(result).to be_success
        end
      end

      context "no callback_mac_payload given" do
        it "returns false" do
          result = described_class.(
            callback_params: callback_params,
            callback_mac_payload: "",
          )

          expect(result).to be_failure
          expect(result.message).to eq "HTTP_X_PAYLOAD_MAC not present"
        end

      end
    end
  end
end
