require "spec_helper"

module StellarBase
  module BridgeCallbacks
    describe GetOperation do
      let(:client) { double(HorizonClient) }
      let(:id) { "1234" }

      context "operation exists" do
        let(:operation_json) { File.read(FIXTURES_DIR.join("operation.json")) }

        it "returns an operation_json from Horizon" do
          expect(client).to receive(:get_operation).with(id).and_return(
            operation_json
          )

          result = described_class.execute(client: client, operation_id: id)

          expect(result.operation_response).to eq operation_json
        end
      end

      context "operation doesn't exist" do
        it "fails the context" do
          expect(client).to receive(:get_operation).with(id).and_return(nil)

          result = described_class.execute(client: client, operation_id: id)

          expect(result).to be_failure
          expect(result.message).to eq "Operation #1234 doesn't exist"
        end

      end

    end
  end
end
