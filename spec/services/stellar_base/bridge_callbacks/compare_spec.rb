require "spec_helper"

module StellarBase
  module BridgeCallbacks
    RSpec.describe Compare do
      let(:operation_json) { File.read(FIXTURES_DIR.join("operation.json")) }
      let(:transaction_json) { File.read(FIXTURES_DIR.join("transaction.json")) }
      let(:ctx) do
        LightService::Context.new(
          operation_response: JSON.parse(operation_json),
          transaction_response: JSON.parse(transaction_json),
          params: params,
        )
      end

      context "callback isn't the same with horizon responses" do
        let(:params) do
          {
            id: "37587135708020737",
            from: "GDORX35OXMJXSYI6HXO2URB5K3GW7UPVB5WR7YC36HAMS2EQEQGDIRKT",
            route: "2",
            amount: "200.0000000",
            asset_code: "",
            asset_issuer: "",
            memo_type: "text",
            memo: "2",
            data: "",
            transaction_id: "4685b3b43512be87586832214da1d3ccd45c4098c2d90b8e3539866debe9652f",
          }
        end

        it "fails the context" do
          result = described_class.execute(ctx)

          expect(result).to be_failure
          expect(result.message).to eq "route, memo value isn't the same"
        end
      end

      context "callback is the same with horizon responses" do
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

        it "doesn't fail the context" do
          result = described_class.execute(ctx)

          expect(result).to be_success
        end
      end
    end
  end
end
