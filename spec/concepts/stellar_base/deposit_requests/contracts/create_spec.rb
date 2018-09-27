require "spec_helper"

module StellarBase
  module DepositRequests
    module Contracts
      RSpec.describe Create do
        describe "validations" do
          %i[
            asset_code
            account_id
          ].each do |attr|
            it "requires #{attr}" do
              contract = described_class.new(DepositRequest.new)
              contract.validate(attr => "")
              expect(contract.errors[attr]).to include("can't be blank")
            end
          end

          context "valid asset_code" do
            it "requires inclusion in depositable_assets" do
              contract = described_class.new(DepositRequest.new)
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
