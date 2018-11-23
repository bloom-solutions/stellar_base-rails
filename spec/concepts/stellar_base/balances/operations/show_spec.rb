require "spec_helper"

module StellarBase
  module Balances
    module Operations
      RSpec.describe Show do

        it "returns a balance object" do
          op = described_class.(balance: { asset_code: "BTCT" })

          expect(op).to be_success

          expect(op["model"].amount).to eq GetMaxAmount::SAMPLE_MAX_AMOUNT
          expect(op["model"].asset_code).to eq "BTCT"
        end

        context "a non-existent asset_code" do
          it "is not successful" do
            op = described_class.(balance: { asset_code: "BCHT" })

            expect(op).to_not be_success

            contract = op["contract.default"]

            expect(contract.errors[:asset_code])
              .to include "invalid asset_code. Valid asset_codes: BTCT"
          end
        end

        context "balances module is not loaded" do
          before do
            StellarBase.configuration.modules = %i[]
          end

          it "creates a withdrawal request" do
            op = described_class.()

            expect(op).to_not be_success
            expect(op["result.policy.default"]).to_not be_success
            expect(op["result.policy.message"])
              .to eq "Not authorized to check balances"
          end
        end

      end
    end
  end
end
