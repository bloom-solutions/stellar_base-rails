require 'spec_helper'

module StellarBase
  module AccountSubscriptions
    RSpec.describe GetRemoteTransaction do

      let(:remote_operation) do
        { "transaction_hash" => transaction_hash }
      end
      let(:client) { InitStellarClient.execute.stellar_sdk_client }

      context "transaction exists in horizon" do
        let(:transaction_hash) do
          "e5da7e9348d877eb42b028cbcfa401e78eeff43a84bc425f1fedc269a70e192c"
        end
        it "returns the tx json of the operation", vcr: {record: :once} do
          result = described_class.execute(
            remote_operation: remote_operation,
            stellar_sdk_client: client,
          )
          expect(result.remote_transaction).to be_a Hash
          expect(result.remote_transaction["fee_paid"]).to eq 100
        end
      end

      context "transaction does not exist in horizon" do
        let(:transaction_hash) { "idonotexist" }

        it "raises a #{NotFoundError}", vcr: {record: :once} do
          expect {
            described_class.execute(
              remote_operation: remote_operation,
              stellar_sdk_client: client,
            )
          }.to raise_error(NotFoundError)
        end
      end

    end
  end
end
