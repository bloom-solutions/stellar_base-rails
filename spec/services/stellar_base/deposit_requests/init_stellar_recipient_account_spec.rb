require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe InitStellarRecipientAccount do
      let(:deposit_request) do
        build_stubbed(:stellar_base_deposit_request, {
          account_id: Stellar::Account.random.address,
        })
      end

      it "sets the stellar_recipient_account in the context" do
        result = described_class.execute(deposit_request: deposit_request)
        account = result.recipient_account

        expect(account).to be_a Stellar::Account
        expect(account.address).to eq deposit_request.account_id
      end
    end
  end
end
