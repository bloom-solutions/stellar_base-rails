require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe CreateDeposit do
      let!(:deposit_request) { create(:stellar_base_deposit_request) }

      it "skips remaining actions" do
        deposit = described_class.execute(
          deposit_request: deposit_request,
          amount: 0.0513,
          tx_id: "2dc",
        ).deposit

        expect(deposit).to be_persisted
        expect(deposit.tx_id).to eq "2dc"
        expect(deposit.amount).to eq 0.0513
        expect(deposit.deposit_request_id).to eq deposit_request.id
      end
    end
  end
end
