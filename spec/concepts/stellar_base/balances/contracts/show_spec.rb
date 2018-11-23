require "spec_helper"

module StellarBase
  module Balances
    module Contracts
      RSpec.describe Show do
        describe "validations" do
          it "requires #{attr}" do
            contract = described_class.new(Balance.new)
            contract.validate(asset_code: "")
            expect(contract.errors[:asset_code]).to include("can't be blank")
          end

          context "valid asset_code" do
            it "requires inclusion in withdrawable_assets" do
              contract = described_class.new(Balance.new)
              contract.validate(asset_code: "BTCH")
              expect(contract.errors[:asset_code])
                .to include "invalid asset_code. Valid asset_codes: BTCT"
            end
          end
        end
      end
    end
  end
end
