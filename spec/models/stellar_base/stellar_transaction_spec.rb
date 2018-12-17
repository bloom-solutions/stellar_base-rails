require "spec_helper"

module StellarBase
  RSpec.describe StellarTransaction, type: %i[model] do

    describe "associations" do
      it do
        is_expected.to have_many(:stellar_operations).
          class_name(StellarBase::StellarOperation.to_s).
          with_primary_key(:transaction_id).
          with_foreign_key(:transaction_hash)
      end
    end

  end
end
