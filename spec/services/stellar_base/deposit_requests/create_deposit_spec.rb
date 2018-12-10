require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe CreateDeposit do
      let!(:deposit_request) do
        create(:stellar_base_deposit_request, {
          asset_code: "BTCT",
          deposit_address: "1bc",
        })
      end
      let(:ctxt) do
        LightService::Context.new(
          deposit_request: deposit_request,
          tx_id: "2dc",
          amount: 2,
        )
      end

      context "deposit exists" do
        let!(:deposit) do
          create(:stellar_base_deposit, {
            tx_id: "2dc",
            deposit_request: deposit_request,
            amount: 1,
          })
        end


        it "fails the context" do
          result = described_class.execute(ctxt)
          expect(result).to be_failure
          expect(result.message).to eq "Deposit already created for tx 2dc"
          expect(result.deposit.id).to eq deposit.id
          expect(result.deposit.tx_id).to eq deposit.tx_id
          expect(result.deposit.amount).to eq 1
        end
      end

      context "deposit does not exist" do
        it "creates the deposit" do
          result = described_class.execute(ctxt)
          expect(result).to be_success
          expect(result.deposit.amount).to eq 2
          expect(result.deposit.deposit_request.id).to eq deposit_request.id
          expect(result.deposit.tx_id).to eq "2dc"
          expect(result.deposit.stellar_tx_id).to be_nil
        end
      end
    end
  end
end
