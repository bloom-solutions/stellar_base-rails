require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe FindDeposit do
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
        )
      end

      context "deposit exists" do
        let!(:deposit) do
          create(:stellar_base_deposit, {
            tx_id: "2dc",
            deposit_request: deposit_request,
          })
        end

        it "skips remaining actions" do
          expect(ctxt).to receive(:skip_remaining!)
          result = described_class.execute(ctxt)
          expect(result.deposit).to be_present
        end
      end

      context "deposit does not exist" do
        it "does not call skip_remaining" do
          expect(ctxt).not_to receive(:skip_remaining!)
          result = described_class.execute(ctxt)
          expect(result.deposit).to be_nil
        end
      end
    end
  end
end
