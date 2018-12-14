require "spec_helper"

module StellarBase
  RSpec.describe StellarOperation, type: %i[virtus] do
    describe "attributes" do
      subject { described_class }
      it { is_expected.to have_attribute(:id, String) }
      it { is_expected.to have_attribute(:paging_token, String) }
      it { is_expected.to have_attribute(:source_account, String) }
      it { is_expected.to have_attribute(:type, String) }
      it { is_expected.to have_attribute(:type_i, String) }
      it { is_expected.to have_attribute(:created_at, DateTime) }
      it { is_expected.to have_attribute(:transaction_hash, String) }
      it { is_expected.to have_attribute(:asset_type, String) }
      it { is_expected.to have_attribute(:asset_code, String) }
      it { is_expected.to have_attribute(:asset_issuer, String) }
      it { is_expected.to have_attribute(:from, String) }
      it { is_expected.to have_attribute(:to, String) }
      it { is_expected.to have_attribute(:amount, BigDecimal) }
    end
  end
end
