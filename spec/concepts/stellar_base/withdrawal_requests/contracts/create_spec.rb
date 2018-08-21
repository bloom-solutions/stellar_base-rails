require 'spec_helper'

module StellarBase
  module WithdrawalRequests
    module Contracts
      RSpec.describe Create do

        describe "validations" do
          %i[
            asset_type
            asset_code
            dest
            issuer
            account_id
            fee_network
            fee_fixed
            fee_percent
          ].each do |attr|
            it "requires #{attr}" do
              contract = described_class.new(WithdrawalRequest.new)
              contract.validate(attr => "")
              expect(contract.errors[attr]).to include("can't be blank")
            end
          end
        end

      end
    end
  end
end
