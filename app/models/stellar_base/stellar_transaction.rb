module StellarBase
  class StellarTransaction

    include Virtus.model

    attribute :id, String
    attribute :hash, String
    attribute :paging_token, String
    attribute :memo, String
    attribute :memo_type, String
    attribute :created_at, DateTime
    attribute :source_account, String
    attribute :source_account_sequence, String
    attribute :ledger, String
    attribute :fee_paid, BigDecimal
    attribute :operation_count, Integer

  end
end
