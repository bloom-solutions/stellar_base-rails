FactoryBot.define do

  factory :stellar_base_stellar_op, class: StellarBase::StellarOp do
    id { "515396079617" }
    paging_token { "515396079617" }
    source_account { "GBRPYHIL2CI3FNQ4BXLFMNDLFJUNPU2HY3ZMFSHONUCEOASW7QC7OX2H" }
    type { "create_account" }
    type_i { 0 }
    created_at { DateTime.parse("2018-10-04T09:36:18Z") }
    transaction_hash { "17a670bc424ff5ce3b386dbfaae9990b66a2a37b4fbe51547e8794962a3f9e6a" }
    starting_balance { "50000000.0000000" }
    funder { "GBRPYHIL2CI3FNQ4BXLFMNDLFJUNPU2HY3ZMFSHONUCEOASW7QC7OX2H" }
    account { "GBS43BF24ENNS3KPACUZVKK2VYPOZVBQO2CISGZ777RYGOPYC2FT6S3K" }
  end

end
