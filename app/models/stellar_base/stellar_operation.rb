module StellarBase
  class StellarOperation

    include Virtus.model

    attribute :id, String
    attribute :paging_token, String
    attribute :source_account, String
    attribute :type, String
    attribute :type_i, String
    attribute :created_at, DateTime
    attribute :transaction_hash, String
    attribute :asset_type, String
    attribute :asset_code, String
    attribute :asset_issuer, String
    attribute :from, String
    attribute :to, String
    attribute :amount, BigDecimal

  end
end
