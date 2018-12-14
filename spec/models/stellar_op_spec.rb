require 'spec_helper'

module StellarBase
  RSpec.describe StellarOp do

    let(:tx_hash) do
      "17a670bc424ff5ce3b386dbfaae9990b66a2a37b4fbe51547e8794962a3f9e6a"
    end
    let(:op_id) { "515396079617" }
    let(:stellar_client) { InitStellarClient.execute.stellar_sdk_client }
    let(:raw_op) do
      stellar_client.horizon.transaction(hash: tx_hash)
        .operations(order: "asc").records.first
    end
    let(:stellar_op) { described_class.new(raw: raw_op) }

    it "exposes attributes in `raw`", vcr: {record: :once} do
      expect(stellar_op.id).to eq op_id
      expect(stellar_op.paging_token).to eq op_id
      expect(stellar_op.source_account).to eq "GBRPYHIL2CI3FNQ4BXLFMNDLFJUNPU2HY3ZMFSHONUCEOASW7QC7OX2H"
      expect(stellar_op.type).to eq "create_account"
      expect(stellar_op.type_i).to eq 0
      expect(stellar_op.created_at).to eq DateTime.parse("2018-10-04T09:36:18Z")
      expect(stellar_op.transaction_hash).to eq tx_hash
      expect(stellar_op.starting_balance).to eq BigDecimal.new("50000000.0000000")
      expect(stellar_op.funder).to eq "GBRPYHIL2CI3FNQ4BXLFMNDLFJUNPU2HY3ZMFSHONUCEOASW7QC7OX2H"
      expect(stellar_op.account).to eq "GBS43BF24ENNS3KPACUZVKK2VYPOZVBQO2CISGZ777RYGOPYC2FT6S3K"

      # does not blow up if attr does not exist
      expect(stellar_op.asset_code).to be_nil
    end

    context "payment attributes" do
      let(:tx_id) { "17a670bc424ff5ce3b386dbfaae9990b66a2a37b4fbe51547e8794962a3f9e6a" }
      let(:op_id) { "515396079624" }
      let(:raw_op) do
        stellar_client.horizon.transaction(hash: tx_hash)
          .operations(order: "asc").records[7]
      end

      it "returns nil", vcr: {record: :once} do
        expect(stellar_op.id).to eq "515396079624"
        expect(stellar_op.paging_token).to eq "515396079624"
        expect(stellar_op.source_account).to eq "GDNFUWF2EO4OWXYLI4TDEH4DXUCN6PB24R6XQW4VATORK6WGMHGRXJVB"
        expect(stellar_op.type).to eq "payment"
        expect(stellar_op.type_i).to eq 1
        expect(stellar_op.created_at).to eq DateTime.parse("2018-10-04T09:36:18Z")
        expect(stellar_op.transaction_hash).to eq "17a670bc424ff5ce3b386dbfaae9990b66a2a37b4fbe51547e8794962a3f9e6a"
        expect(stellar_op.asset_type).to eq "credit_alphanum4"
        expect(stellar_op.asset_code).to eq "TEST"
        expect(stellar_op.asset_issuer).to eq "GDNFUWF2EO4OWXYLI4TDEH4DXUCN6PB24R6XQW4VATORK6WGMHGRXJVB"
        expect(stellar_op.from).to eq "GDNFUWF2EO4OWXYLI4TDEH4DXUCN6PB24R6XQW4VATORK6WGMHGRXJVB"
        expect(stellar_op.to).to eq "GAAJKG3WQKHWZJ5RGVVZMVV6X3XYU7QUH2YVATQ2KBVR2ZJYLG35Z65A"
        expect(stellar_op.amount).to eq BigDecimal.new("1000000.0000000")
      end
    end

  end
end
