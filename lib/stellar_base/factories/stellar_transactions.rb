FactoryBot.define do
  factory :stellar_base_stellar_transaction, class: "StellarBase::StellarTransaction" do
    id { "1234" }
    paging_token { "1234" }
    ledger { 120 }
    created_at { DateTime.parse("2018-10-04T09:36:18Z") }
    source_account { "G-SOURCE" }
    source_account_sequence { "1" }
    fee_paid { 1000 }
    operation_count { 10 }
    envelope_xdr { "AAA" }
    result_xdr { "BBB" }
    result_meta_xdr { "CCC" }
    fee_meta_xdr { "DDD" }
    memo_type { "none" }
    signatures do
      [
        "SIG1===",
        "SIG2===",
        "SIG3===",
        "SIG4===",
      ]
    end

    skip_create
  end
end
