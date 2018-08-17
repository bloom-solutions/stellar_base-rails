require 'spec_helper'

module StellarBase
  module WithdrawalRequests
    RSpec.describe CallOnWithdraw do

      let(:bridge_callback) { build_stubbed(:stellar_base_bridge_callback) }
      let(:withdrawal_request) { build_stubbed(:stellar_base_bridge_callback) }

      context ".on_withdraw is a proc" do
        it "calls the proc" do
          callback = ->(withdrawal_request, bridge_callback) do
            @withdrawal_request = withdrawal_request
            @bridge_callback = bridge_callback
          end

          described_class.execute({
            withdrawal_request: withdrawal_request,
            bridge_callback: bridge_callback,
            on_withdraw: callback,
          })

          expect(@withdrawal_request).to eq withdrawal_request
          expect(@bridge_callback).to eq bridge_callback
        end
      end

      context ".on_withdraw is string of a class that exists" do
        it "constantizes it and executes `.call`" do
          expect(ProcessWithdrawal).to receive(:call).with(
            withdrawal_request,
            bridge_callback,
          )

          described_class.execute({
            withdrawal_request: withdrawal_request,
            bridge_callback: bridge_callback,
            on_withdraw: ProcessWithdrawal.to_s,
          })
        end
      end

      context ".on_withdraw is an object that responds to `.call`" do
        it "executes `.call`" do
          expect(ProcessWithdrawal).to receive(:call).with(
            withdrawal_request,
            bridge_callback,
          )

          described_class.execute({
            withdrawal_request: withdrawal_request,
            bridge_callback: bridge_callback,
            on_withdraw: ProcessWithdrawal,
          })
        end
      end

      context ".on_withdraw is an object that does not respond to `.call`" do
        it "raises an error" do
          expect(ProcessWithdrawal).to_not receive(:call)

          expect {
            described_class.execute({
              withdrawal_request: withdrawal_request,
              bridge_callback: bridge_callback,
              on_withdraw: {},
            })
          }.to raise_error(ArgumentError, described_class::ON_WITHDRAW_ERROR)
        end
      end

    end
  end
end
