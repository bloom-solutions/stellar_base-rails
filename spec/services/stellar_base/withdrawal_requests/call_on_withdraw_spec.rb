require 'spec_helper'

module StellarBase
  module WithdrawalRequests
    RSpec.describe CallOnWithdraw do

      let(:op) { build_stubbed(:stellar_base_stellar_operation) }
      let(:withdrawal_request) do
        build_stubbed(:stellar_base_withdrawal_request)
      end

      context ".on_withdraw is a proc" do
        it "calls the proc" do
          callback = ->(withdrawal_request, op) do
            @withdrawal_request = withdrawal_request
            @op = op
          end

          described_class.execute(
            withdrawal_request: withdrawal_request,
            stellar_operation: op,
            on_withdraw: callback,
          )

          expect(@withdrawal_request).to eq withdrawal_request
          expect(@op).to eq op
        end
      end

      context ".on_withdraw is string of a class that exists" do
        it "constantizes it and executes `.call`" do
          expect(ProcessWithdrawal).to receive(:call).with(
            withdrawal_request,
            op,
          )

          described_class.execute({
            withdrawal_request: withdrawal_request,
            stellar_operation: op,
            on_withdraw: ProcessWithdrawal.to_s,
          })
        end
      end

      context ".on_withdraw is an object that responds to `.call`" do
        it "executes `.call`" do
          expect(ProcessWithdrawal).to receive(:call).with(
            withdrawal_request,
            op,
          )

          described_class.execute({
            withdrawal_request: withdrawal_request,
            stellar_operation: op,
            on_withdraw: ProcessWithdrawal.to_s,
          })
        end
      end

      context ".on_withdraw is an object that does not respond to `.call`" do
        it "raises an error" do
          expect(ProcessWithdrawal).to_not receive(:call)

          expect {
            described_class.execute(
              withdrawal_request: withdrawal_request,
              stellar_operation: op,
              on_withdraw: {},
            )
          }.to raise_error(ArgumentError, described_class::ON_WITHDRAW_ERROR)
        end
      end

      context ".on_withdraw is nil" do
        it "does nothing" do
          result = described_class.execute(
            withdrawal_request: withdrawal_request,
            stellar_operation: op,
            on_withdraw: nil,
          )

          expect(result).to be_success
        end
      end

    end
  end
end
