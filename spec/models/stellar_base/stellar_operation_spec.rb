require "spec_helper"

module StellarBase
  RSpec.describe StellarOperation, type: %i[virtus] do
    describe "attributes" do
      subject { described_class }
      it { is_expected.to have_attribute(:id, String) }
      it { is_expected.to have_attribute(:paging_token, String) }
      it { is_expected.to have_attribute(:source_account, String) }
      it { is_expected.to have_attribute(:type, String) }
      it { is_expected.to have_attribute(:type_i, Integer) }
      it { is_expected.to have_attribute(:created_at, DateTime) }
      it { is_expected.to have_attribute(:transaction_hash, String) }
      it { is_expected.to have_attribute(:asset_type, String) }
      it { is_expected.to have_attribute(:asset_code, String) }
      it { is_expected.to have_attribute(:asset_issuer, String) }
      it { is_expected.to have_attribute(:from, String) }
      it { is_expected.to have_attribute(:to, String) }
      it { is_expected.to have_attribute(:amount, BigDecimal) }
      it { is_expected.to have_attribute(:account, String) }
      it { is_expected.to have_attribute(:funder, String) }
      it { is_expected.to have_attribute(:starting_balance, BigDecimal) }
    end

    context "payment attributes" do
      let(:tx_hash) do
        "17a670bc424ff5ce3b386dbfaae9990b66a2a37b4fbe51547e8794962a3f9e6a"
      end
      let(:op_id) { "515396079617" }
      let(:stellar_client) { InitStellarClient.execute.stellar_sdk_client }
      let(:raw_op) do
        stellar_client.horizon.transaction(hash: tx_hash)
          .operations(order: "asc").records[8]
      end
      let(:stellar_op) { described_class.new(raw: raw_op) }

      it "returns the parsed object", vcr: {record: :once} do
        expect(stellar_op.id).to eq "515396079625"
        expect(stellar_op.paging_token).to eq "515396079625"
        expect(stellar_op.source_account)
          .to eq "GDNFUWF2EO4OWXYLI4TDEH4DXUCN6PB24R6XQW4VATORK6WGMHGRXJVB"
        expect(stellar_op.type).to eq "payment"
        expect(stellar_op.type_i).to eq 1
        expect(stellar_op.created_at)
          .to eq DateTime.parse("2018-10-04T09:36:18Z")
        expect(stellar_op.transaction_hash)
          .to eq "17a670bc424ff5ce3b386dbfaae9990b66a2a37b4fbe51547e8794962a3f9e6a"
        expect(stellar_op.asset_type).to eq "credit_alphanum4"
        expect(stellar_op.asset_code).to eq "TEST"
        expect(stellar_op.asset_issuer)
          .to eq "GDNFUWF2EO4OWXYLI4TDEH4DXUCN6PB24R6XQW4VATORK6WGMHGRXJVB"
        expect(stellar_op.from)
          .to eq "GDNFUWF2EO4OWXYLI4TDEH4DXUCN6PB24R6XQW4VATORK6WGMHGRXJVB"
        expect(stellar_op.to)
          .to eq "GCNP7JE6KR5CKHMVVFTZJUSP7ALAXWP62SK6IMIY4IF3JCHEZKBJKDZF"
        expect(stellar_op.amount).to eq BigDecimal.new("1000000.0000000")
      end
    end
  end
end
