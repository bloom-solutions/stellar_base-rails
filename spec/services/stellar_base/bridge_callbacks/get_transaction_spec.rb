require "spec_helper"

module StellarBase
  module BridgeCallbacks
    describe GetTransaction do
      let(:client) { double(HorizonClient) }
      let(:id) { "1234" }

      context "transaction exists" do
        let(:transaction_json) do
          File.read(FIXTURES_DIR.join("transaction.json"))
        end

        it "returns a transaction_json from Horizon" do
          expect(client).to receive(:get_transaction).with(id).and_return(
            transaction_json
          )

          result = described_class.execute(client: client, transaction_id: id)

          expect(result.transaction_response).to eq transaction_json
        end
      end

      context "transaction doesn't exist" do
        it "fails the context" do
          expect(client).to receive(:get_transaction).with(id).and_return(nil)

          result = described_class.execute(client: client, transaction_id: id)

          expect(result).to be_failure
          expect(result.message).to eq "Transaction #1234 doesn't exist"
        end

      end

    end
  end
end
