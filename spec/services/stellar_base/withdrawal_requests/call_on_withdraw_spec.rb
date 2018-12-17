require 'spec_helper'

module StellarBase
  module WithdrawalRequests
    RSpec.describe CallOnWithdraw do

      let(:tx) { build_stubbed(:stellar_base_stellar_transaction) }
      let(:op) { build_stubbed(:stellar_base_stellar_operation) }
      let(:withdrawal_request) do
        build_stubbed(:stellar_base_withdrawal_request)
      end

      context ".on_withdraw is a proc" do
        it "calls the proc" do
          callback = ->(withdrawal_request, tx, op) do
            @withdrawal_request = withdrawal_request
            @tx = tx
            @op = op
          end

          described_class.execute(
            withdrawal_request: withdrawal_request,
            transaction: tx,
            operation: op,
            on_withdraw: callback,
          )

          expect(@withdrawal_request).to eq withdrawal_request
          expect(@tx).to eq tx
          expect(@op).to eq op
        end
      end

      context ".on_withdraw is string of a class that exists" do
        it "constantizes it and executes `.call`" do
          expect(ProcessWithdrawal).to receive(:call).with(
            withdrawal_request,
            tx,
            op,
          )

          described_class.execute({
            withdrawal_request: withdrawal_request,
            transaction: tx,
            operation: op,
            on_withdraw: ProcessWithdrawal.to_s,
          })
        end
      end

      context ".on_withdraw is an object that responds to `.call`" do
        it "executes `.call`" do
          expect(ProcessWithdrawal).to receive(:call).with(
            withdrawal_request,
            tx,
            op,
          )

          described_class.execute({
            withdrawal_request: withdrawal_request,
            transaction: tx,
            operation: op,
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
              transaction: tx,
              operation: op,
              on_withdraw: {},
            )
          }.to raise_error(ArgumentError, described_class::ON_WITHDRAW_ERROR)
        end
      end

    end
  end
end
