require 'spec_helper'

module StellarBase
  module WithdrawalRequests
    RSpec.describe CallFeeFixedFrom do

      let(:params) do
        {}
      end

      context "`fee_fixed` is set in the configuration" do
        let(:asset_details) { { fee_fixed: 0.123 } }

        it "returns `fee_fixed`" do
          result = described_class.(params, asset_details)
          expect(result).to eq 0.123
        end
      end

      context "`fee_fixed` is not set in the configuration" do
        context "custom fee_fixed config returns a value" do
          let(:params) do
            { dest_extra: {fee_fixed: 1.23}.to_json }
          end
          let(:asset_details) do
            {
              fee_fixed_from: ->(params, asset_details) do
                JSON.parse(params[:dest_extra])["fee_fixed"]
              end
            }
          end

          it "returns the result of `fixed_fee_from` proc" do
            result = described_class.(params, asset_details)
            expect(result).to eq 1.23
          end
        end

        context "custom fee_fixed config returns nil" do
          let(:asset_details) do
            {
              type: "crypto",
              network: "bitcoin",
              asset_code: "BTCT",
              issuer: ENV["ISSUER_ADDRESS"],
              fee_fixed_from: ->(params, asset_details) { nil },
            }
          end

          it "raises an error" do
            expect {
              described_class.(params, asset_details)
            }.to raise_error(
              ArgumentError,
              described_class::INVALID_FEE_MESSAGE
            )
          end
        end
      end

    end
  end
end
