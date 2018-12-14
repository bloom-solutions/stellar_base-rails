require 'spec_helper'

module StellarBase
  RSpec.describe StellarTx do

    let(:tx_hash) do
      "961b7fb0a551760d59d063f1ebbd6cf1a2dad6e3c3774308c16bdd43ddebf1cf"
    end
    let(:stellar_client) { InitStellarClient.execute.stellar_sdk_client }
    let(:raw_tx) { stellar_client.horizon.transaction(hash: tx_hash) }
    let(:stellar_tx) do
      described_class.new(raw: raw_tx)
    end

    it "exposes the attributes in `raw`", vcr: {record: :once} do
      expect(stellar_tx.id).to eq "961b7fb0a551760d59d063f1ebbd6cf1a2dad6e3c3774308c16bdd43ddebf1cf"
      expect(stellar_tx.paging_token).to eq "1236950585344"
      expect(stellar_tx.ledger).to eq 288
      expect(stellar_tx.created_at).to eq "2018-10-04T09:51:36Z"
      expect(stellar_tx.source_account).to eq "GAUWNA5UBA77Q7WUTF674UHUOLKZHSM44N3ZBMXUHVFSKWET24Y3PJ44"
      expect(stellar_tx.source_account_sequence).to eq "850403524611"
      expect(stellar_tx.fee_paid).to eq 100
      expect(stellar_tx.operation_count).to eq 1
      expect(stellar_tx.envelope_xdr).to eq "AAAAAClmg7QIP/h+1Jl9/lD0ctWTyZzjd5Cy9D1LJViT1zG3AAAAZAAAAMYAAAADAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAABAAAACmhlbGxvd29ybGQAAAAAAAEAAAAAAAAAAQAAAAC9yOHhCstIND/fN10EjlOhqlvgjqU3qDtfd4AMqQSENgAAAAAAAAAAO5rKAAAAAAAAAAABk9cxtwAAAED/nZ8MgyPf/vZIFQSl71BcYmuILV2iUJ5vJdHF3HcmDejvB2QKO7EFGPoiJamkswMAWyvoyOLmQhJj+8O2MU4P"
      expect(stellar_tx.result_xdr).to eq "AAAAAAAAAGQAAAAAAAAAAQAAAAAAAAABAAAAAAAAAAA="
      expect(stellar_tx.result_meta_xdr).to eq "AAAAAQAAAAAAAAABAAAAAwAAAAEAAAEgAAAAAAAAAAApZoO0CD/4ftSZff5Q9HLVk8mc43eQsvQ9SyVYk9cxtwAAABcM3BzUAAAAxgAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAMAAAESAAAAAAAAAAC9yOHhCstIND/fN10EjlOhqlvgjqU3qDtfd4AMqQSENgAAABdIdugAAAABEgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAEgAAAAAAAAAAC9yOHhCstIND/fN10EjlOhqlvgjqU3qDtfd4AMqQSENgAAABeEEbIAAAABEgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA=="
      expect(stellar_tx.fee_meta_xdr).to eq "AAAAAgAAAAMAAAEFAAAAAAAAAAApZoO0CD/4ftSZff5Q9HLVk8mc43eQsvQ9SyVYk9cxtwAAABdIduc4AAAAxgAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAEAAAEgAAAAAAAAAAApZoO0CD/4ftSZff5Q9HLVk8mc43eQsvQ9SyVYk9cxtwAAABdIdubUAAAAxgAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAA=="
      expect(stellar_tx.memo).to eq "helloworld"
      expect(stellar_tx.memo_type).to eq "text"
      expect(stellar_tx.signatures).to eq([
        "/52fDIMj3/72SBUEpe9QXGJriC1dolCebyXRxdx3Jg3o7wdkCjuxBRj6IiWppLMDAFsr6Mji5kISY/vDtjFODw=="
      ])
      expect(stellar_tx.valid_after).to eq DateTime.parse("1970-01-01T00:00:00Z")
    end

    context "memo does not exist" do
      let(:tx_hash) { "17a670bc424ff5ce3b386dbfaae9990b66a2a37b4fbe51547e8794962a3f9e6a" }

      it "returns nil", vcr: {record: :once} do
        expect(stellar_tx.memo).to be_nil
        expect(stellar_tx.memo_type).to eq "none"
      end
    end

  end
end
