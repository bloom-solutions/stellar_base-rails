require "spec_helper"

module StellarBase
  module FeeRequests
    module Contracts
      RSpec.describe Show do
        describe "validations" do
          %i[
            operation
            asset_code
            amount
          ].each do |attr|
            it "requires #{attr}" do
              contract = described_class.new(FeeRequest.new)
              contract.validate(attr => "")
              expect(contract.errors[attr]).to include("can't be blank")
            end
          end

          context "valid asset_code" do
            it "requires inclusion in withdrawable_assets" do
              withdraw_contract = described_class.new(FeeRequest.new)
              withdraw_contract.validate(
                operation: "withdraw",
                asset_code: "BTCH",
              )
              expect(withdraw_contract.errors[:asset_code])
                .to include "invalid asset_code. Valid asset_codes: BTCT"

              deposit_contract = described_class.new(FeeRequest.new)
              deposit_contract.validate(
                operation: "deposit",
                asset_code: "BTCH",
              )
              expect(deposit_contract.errors[:asset_code])
                .to include "invalid asset_code. Valid asset_codes: BTCT"
            end
          end
        end
      end
    end
  end
end
