require 'spec_helper'

module StellarBase
  module AccountSubscriptions
    RSpec.describe FindOrCreateTransaction do

      context "StellarTransaction does not exist" do
        context "without memo" do
          let(:remote_transaction) do
            {"id" => "txhash", "memo_type" => "none"}
          end

          it "creates the record" do
            result = described_class.
              execute(remote_transaction: remote_transaction)

            tx = result.stellar_transaction

            expect(tx).to be_present
            expect(tx).to be_a StellarTransaction
            expect(tx.transaction_id).to eq "txhash"
            expect(tx.memo).to be_nil
            expect(tx.memo_type).to eq "none"
          end
        end

        context "with memo" do
          let(:remote_transaction) do
            {"id" => "txhash", "memo_type" => "text", "memo" => "VA"}
          end

          it "creates the record" do
            result = described_class.
              execute(remote_transaction: remote_transaction)

            tx = result.stellar_transaction

            expect(tx).to be_present
            expect(tx).to be_a StellarTransaction
            expect(tx.transaction_id).to eq "txhash"
            expect(tx.memo).to eq "VA"
            expect(tx.memo_type).to eq "text"
          end
        end
      end

      context "StellarTransaction already exists" do
        let(:remote_transaction) { {"id" => "txhash"} }
        let!(:stellar_transaction) do
          create(:stellar_base_stellar_transaction, transaction_id: "txhash")
        end

        it "sets the existing transaction" do
          result = described_class.execute(remote_transaction: remote_transaction)
          expect(result.stellar_transaction).to eq stellar_transaction
        end
      end

    end
  end
end
