require "spec_helper"

module StellarBase
  module WithdrawalRequests
    module Contracts
      RSpec.describe Create do
        describe "validations" do
          %i[
            asset_type
            asset_code
            dest
            fee_fixed
          ].each do |attr|
            it "requires #{attr}" do
              contract = described_class.new(WithdrawalRequest.new)
              contract.validate(attr => "")
              expect(contract.errors[attr]).to include("can't be blank")
            end
          end

          it "fee_fixed must be >= 0" do
            contract = described_class.new(WithdrawalRequest.new)
            contract.validate(fee_fixed: -1)
            expect(contract.errors[:fee_fixed]).
              to include("must be greater than or equal to 0")

            contract = described_class.new(WithdrawalRequest.new)
            contract.validate(fee_fixed: 0)
            expect(contract.errors[:fee_fixed]).to be_empty
          end

          context "valid asset_code" do
            it "requires inclusion in withdrawable_assets" do
              contract = described_class.new(WithdrawalRequest.new)
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
