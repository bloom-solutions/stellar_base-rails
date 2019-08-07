require 'spec_helper'

module StellarBase
  module FeeRequests
    RSpec.describe CallFeeFrom do
      let(:fee_request) { build(:stellar_base_fee_request) }

      context ".fixed_fee_quote_from is a proc" do
        it "calls the proc" do
          callback = -> (fee_request) do
            @fee_request = fee_request
          end

          described_class.(
            fee_request: fee_request,
            fixed_fee_quote_from: callback,
          )

          expect(@fee_request).to eq fee_request
        end
      end

      context ".fixed_fee_quote_from is string of a class that exists" do
        it "constantizes it and executes `.call`" do
          expect(ProcessFeeFrom).to receive(:call).with(fee_request)

          described_class.(
            fee_request: fee_request,
            fixed_fee_quote_from: ProcessFeeFrom.to_s,
          )
        end
      end

      context ".fixed_fee_quote_from is an object that responds to `.call`" do
        it "executes `.call`" do
          expect(ProcessFeeFrom).to receive(:call).with(fee_request)

          described_class.(
            fee_request: fee_request,
            fixed_fee_quote_from: ProcessFeeFrom,
          )
        end
      end

      context ".fixed_fee_quote_from is an object that does not respond to `.call`" do
        it "raises an error" do
          expect {
            described_class.(
              fee_request: fee_request,
              fixed_fee_quote_from: ProcessFailedFeeFrom,
            )
          }.to raise_error(
            ArgumentError,
            described_class::FIXED_FEE_QUOTE_FROM_ERROR
          )
        end
      end

      context ".fixed_fee_quote_from is nil" do
        it "does nothing" do
          result = described_class.(
            fee_request: fee_request,
            fixed_fee_quote_from: nil,
          )

          expect(result).to be_zero
        end
      end

    end
  end
end
