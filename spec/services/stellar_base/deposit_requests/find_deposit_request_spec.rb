require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe FindDepositRequest do
      context "deposit request exists" do
        let!(:deposit_request) do
          create(:stellar_base_deposit_request, {
            asset_code: "BTCT",
            deposit_address: "1bc",
          })
        end
        let(:deposit_config) do
          FindConfig.execute(network: "bitcoin").deposit_config
        end

        it "sets deposit_request on the context" do
          resulting_ctx = described_class.execute(
            deposit_config: deposit_config,
            deposit_address: "1bc",
          )

          expect(resulting_ctx.deposit_request).to eq deposit_request
        end
      end

      context "deposit request does not exist" do
        let(:deposit_config) do
          FindConfig.execute(network: "bitcoin").deposit_config
        end

        it "does nothing" do
          result = described_class.execute(
            deposit_config: deposit_config,
            deposit_address: "1bc",
          )

          expect(result).to be_skip_remaining
          expect(result.message).to eq "No DepositRequest found for BTCT:1bc"

          deposit_request = result.deposit_request

          expect(deposit_request).to be_nil
        end
      end
    end
  end
end
