require 'spec_helper'

module StellarBase
  module AccountSubscriptions
    RSpec.describe FindOrCreateOperation do

      let!(:stellar_transaction) do
        create(:stellar_base_stellar_transaction, transaction_id: "hash")
      end

      context "StellarOperation does not exist" do
        let(:remote_operation) do
          {
            "id" => "921",
            "transaction_hash" => "hash",
            "type" => "payment",
            "asset_code" => "BTCT",
            "asset_issuer" => "GISSUER",
            "from" => "GFROM",
            "to" => "GTO",
            "amount" => "0.01234567",
          }
        end

        it "creates the record" do
          result = described_class.execute(remote_operation: remote_operation)

          op = result.stellar_operation

          expect(op).to be_present
          expect(op).to be_a StellarPayment
          expect(op.operation_id).to eq "921"
          expect(op.transaction_hash).to eq "hash"
          expect(op.asset_code).to eq "BTCT"
          expect(op.asset_issuer).to eq "GISSUER"
          expect(op.from).to eq "GFROM"
          expect(op.to).to eq "GTO"
          expect(op.amount).to eq BigDecimal("0.01234567")
        end
      end

      context "unsupported type" do
        let!(:stellar_transaction) do
          create(:stellar_base_stellar_transaction, transaction_id: "hash")
        end
        let(:remote_operation) do
          {
            "id" => "921",
            "transaction_hash" => "hash",
            "type" => "create_account",
          }
        end

        it "creates the stellar_operation saving basic data" do
          result = described_class.execute(remote_operation: remote_operation)

          op = result.stellar_operation

          expect(op).to be_present
          expect(op.operation_id).to eq "921"
          expect(op.transaction_hash).to eq "hash"
        end
      end

      context "StellarOperation already exists" do
        let(:remote_operation) { {"id" => "921"} }
        let!(:stellar_operation) do
          create(:stellar_base_stellar_operation, operation_id: "921")
        end

        it "sets the existing operation" do
          result = described_class.execute(remote_operation: remote_operation)
          expect(result.stellar_operation).to eq stellar_operation
        end
      end

    end
  end
end
