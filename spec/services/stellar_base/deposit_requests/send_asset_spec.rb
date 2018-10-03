require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe SendAsset do
      let(:distribution_account) { Stellar::Account.random }
      let(:recipient_account) { Stellar::Account.random }
      let(:issuer_account) { Stellar::Account.random }
      let(:client) { InitStellarClient.execute.stellar_sdk_client }
      let(:deposit_request) do
        build_stubbed(:stellar_base_deposit_request, memo: "ABC")
      end
      let(:stellar_amount) { Stellar::Amount.new(1.0) }

      context "no errors" do
        let(:response) do
          double(Hyperclient::Resource, to_hash: {
            "hash" => "stellar-tx-hash",
          })
        end

        it "sends the client" do
          expect(client).to receive(:send_payment).with(
            from: distribution_account,
            to: recipient_account,
            amount: stellar_amount,
            memo: "ABC",
          ).and_return(response)

          described_class.execute(
            deposit_request: deposit_request,
            distribution_account: distribution_account,
            issuer_account: issuer_account,
            recipient_account: recipient_account,
            stellar_amount: stellar_amount,
            stellar_sdk_client: client,
          )
        end
      end

      context "there are errors" do
        let(:error) { Faraday::ClientError.new("message") }

        it "sends the client" do
          expect(client).to receive(:send_payment).with(
            from: distribution_account,
            to: recipient_account,
            amount: stellar_amount,
            memo: "ABC",
          ).and_raise(error)

          result = described_class.execute(
            deposit_request: deposit_request,
            distribution_account: distribution_account,
            issuer_account: issuer_account,
            recipient_account: recipient_account,
            stellar_amount: stellar_amount,
            stellar_sdk_client: client,
          )

          expect(result).to be_failure
          expect(result.message)
            .to eq "Error sending the asset. Faraday::ClientError: message"
        end
      end
    end
  end
end
