require "spec_helper"

module StellarBase
  RSpec.describe StellarOperation, type: %i[model] do

    describe "associations" do
      it do
        is_expected.to belong_to(:stellar_transaction).
          class_name(StellarBase::StellarTransaction.to_s).
          with_primary_key(:transaction_id).
          with_foreign_key(:transaction_hash)
      end
    end

  end
end
