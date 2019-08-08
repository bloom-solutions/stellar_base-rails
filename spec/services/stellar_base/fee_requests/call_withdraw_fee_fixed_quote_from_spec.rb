require 'spec_helper'

module StellarBase
  module FeeRequests
    RSpec.describe CallWithdrawFeeFixedQuoteFrom do
      let(:fee_request) { build(:stellar_base_fee_request) }

      context "`fee_fixed` is set in the config" do
        before do
          StellarBase.configuration.withdrawable_assets = [
            {
              type: "crypto",
              network: "bitcoin",
              asset_code: "BTCT",
              issuer: ENV["ISSUER_ADDRESS"],
              fee_fixed: 0.01,
            },
          ]
        end

        it "returns the `fee_fixed` amount" do
          result = described_class.(
            fee_request: fee_request,
            fee_fixed_quote_from: ->(fee_request) {},
          )
          expect(result).to eq 0.01
        end
      end

      context ".fee_fixed_quote_from is a proc" do
        it "calls the proc" do
          callback = -> (fee_request) do
            @fee_request = fee_request
          end

          described_class.(
            fee_request: fee_request,
            fee_fixed_quote_from: callback,
          )

          expect(@fee_request).to eq fee_request
        end
      end

      context ".fee_fixed_quote_from is string of a class that exists" do
        it "constantizes it and executes `.call`" do
          expect(ProcessFeeFrom).to receive(:call).with(fee_request)

          described_class.(
            fee_request: fee_request,
            fee_fixed_quote_from: ProcessFeeFrom.to_s,
          )
        end
      end

      context ".fee_fixed_quote_from is an object that responds to `.call`" do
        it "executes `.call`" do
          expect(ProcessFeeFrom).to receive(:call).with(fee_request)

          described_class.(
            fee_request: fee_request,
            fee_fixed_quote_from: ProcessFeeFrom,
          )
        end
      end

      context ".fee_fixed_quote_from is an object that does not respond to `.call`" do
        it "raises an error" do
          expect {
            described_class.(
              fee_request: fee_request,
              fee_fixed_quote_from: ProcessFailedFeeFrom,
            )
          }.to raise_error(
            ArgumentError,
            described_class::FEE_FIXED_QUOTE_FROM_ERROR
          )
        end
      end

      context ".fee_fixed_quote_from is nil" do
        it "does nothing" do
          result = described_class.(
            fee_request: fee_request,
            fee_fixed_quote_from: nil,
          )

          expect(result).to be_zero
        end
      end

    end
  end
end
