require "spec_helper"

module StellarBase
  module BridgeCallbacks
    module MacPayloads
      RSpec.describe EncodeParams do
        let(:params) do
          {
            id: "37587135708020737",
            from: "GDORX35OXMJXSYI6HXO2URB5K3GW7UPVB5WR7YC36HAMS2EQEQGDIRKT",
            route: "BX857D13E",
            amount: "200.0000000",
            asset_code: "",
            asset_issuer: "",
            memo_type: "text",
            memo: "BX857D13E",
            data: "",
            transaction_id: "4685b3b43512be87586832214da1d3ccd45c4098c2d90b8e3539866debe9652f",
          }
        end
        let(:mac_key) { "TEST" }
        let(:expected_encoded_params) do
          OpenSSL::HMAC.digest("SHA256", mac_key, params.to_query)
        end

        it "encodes the current callback_params" do
          result = described_class.execute(
            callback_params: params,
            decoded_mac_key: mac_key,
          )

          expect(result.encoded_params).to eq expected_encoded_params
        end
      end
    end
  end
end
