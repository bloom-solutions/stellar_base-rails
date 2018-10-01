require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe SendAsset do
      context "no errors" do
        let(:client) { InitStellarClient.execute.stellar_client }
        let(:deposit_request) do
          build_stubbed(:stellar_base_deposit_request, memo: "ABC")
        end
        let(:distribution_account) { Stellar::Account.random }
        let(:recipient_account) { Stellar::Account.random }
        let(:stellar_amount) { Stellar::Amount.native(1.0) }

        it "sends the client" do
          expect(stellar_client).to receive(:send_payment).with(
            from: distribution_account,
            to: recipient,
            amount: stellar_amount,
            memo: "ABC",
          )

          described_class.execute(
            recipient_account: stellar_recipient_account,
            distribution_account: stellar_distribution_account,
            stellar_amount: stellar_amount,
            stellar_sdk_client: client,
          )
        end
      end

      context "there are errors" do
        let(:stellar_client) { InitStellarClient.execute.stellar_client }
        let(:stellar_distribution_account) { Stellar::Account.random }
        let(:stellar_amount) { Stellar::Amount.native(1.0) }
        let(:deposit_request) do
          build_stubbed(:stellar_base_deposit_request, memo: "ABC")
        end
        let(:error) { Faraday::ClientError.new("message") }

        it "sends the client" do
          expect(stellar_client).to receive(:send_payment).with(
            from: account,
            to: recipient,
            amount: stellar_amount,
            memo: "ABC",
          ).and_raise(error)

          resulting_ctx = described_class.execute(
            stellar_recipient_account: stellar_recipient_account,
            stellar_distribution_account: stellar_distribution_account,
            stellar_amount: stellar_amount,
            stellar_client: stellar_client,
          )

          expect(resulting_ctx).to be_failure
          expect(resulting_ctx).to be_skip_remaining
          expect(resulting_ctx.message)
            .to eq "Error sending the asset. Faraday::ClientError: message"
        end
      end
    end
  end
end
