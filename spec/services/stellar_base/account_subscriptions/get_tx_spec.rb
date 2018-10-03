require 'spec_helper'

module StellarBase
  module AccountSubscriptions
    RSpec.describe GetTx do

      let(:operation) do
        double(transaction_hash: "f6cc222697da5c453d2652a8088c20cab20a21bcbb50556b517b6b1ecd36cc77")
      end
      let(:client) { InitStellarClient.execute.stellar_sdk_client }

      it "returns the tx json of the operation", vcr: {record: :once} do
        resulting_ctx = described_class.execute({
          operation: operation,
          stellar_sdk_client: client,
        })
        expect(resulting_ctx.tx.fee_paid).to eq 100
      end

    end
  end
end
