require "spec_helper"

module StellarBase
  RSpec.describe StellarTransaction, type: %i[virtus] do
    describe "attributes" do
      subject { described_class }
      it { is_expected.to have_attribute(:id, String) }
      it { is_expected.to have_attribute(:hash, String) }
      it { is_expected.to have_attribute(:paging_token, String) }
      it { is_expected.to have_attribute(:memo, String) }
      it { is_expected.to have_attribute(:memo_type, String) }
      it { is_expected.to have_attribute(:created_at, DateTime) }
      it { is_expected.to have_attribute(:source_account, String) }
      it { is_expected.to have_attribute(:source_account_sequence, String) }
      it { is_expected.to have_attribute(:ledger, String) }
      it { is_expected.to have_attribute(:fee_paid, BigDecimal) }
      it { is_expected.to have_attribute(:operation_count, Integer) }
    end
  end
end
