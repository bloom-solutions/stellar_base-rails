require 'spec_helper'

module StellarBase
  module AccountSubscriptions
    RSpec.describe GetRemoteTransaction do

      let(:remote_operation) do
        double(
          transaction_hash: "f6cc222697da5c453d2652a8088c20cab20a21bcbb50556b517b6b1ecd36cc77",
        )
      end
      let(:client) { InitStellarClient.execute.stellar_sdk_client }

      it "returns the tx json of the operation", vcr: {record: :once} do
        result = described_class.execute(
          remote_operation: remote_operation,
          stellar_sdk_client: client,
        )
        expect(result.remote_transaction).to be_a Hash
        expect(result.remote_transaction["fee_paid"]).to eq 100
      end

    end
  end
end
