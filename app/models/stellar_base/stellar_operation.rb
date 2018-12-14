module StellarBase
  class StellarOperation

    include Virtus.model

    attribute :raw, Object
    attribute :id, String, default: :default_id, lazy: true
    attribute :paging_token, String, default: :default_paging_token, lazy: true
    attribute :source_account, String, default: :default_source_account, lazy: true
    attribute :type, String, default: :default_type, lazy: true
    attribute :type_i, Integer, default: :default_type_i, lazy: true
    attribute :created_at, DateTime, default: :default_created_at, lazy: true
    attribute :transaction_hash, String, default: :default_transaction_hash, lazy: true
    attribute :asset_type, String, default: :default_asset_type, lazy: true
    attribute :asset_code, String, default: :default_asset_code, lazy: true
    attribute :asset_issuer, String, default: :default_asset_issuer, lazy: true
    attribute :from, String, default: :default_from, lazy: true
    attribute :to, String, default: :default_to, lazy: true
    attribute :amount, BigDecimal, default: :default_amount, lazy: true
    attribute :starting_balance, BigDecimal, default: :default_starting_balance, lazy: true
    attribute :funder, String, default: :default_funder, lazy: true
    attribute :account, String, default: :default_account, lazy: true

    private

    %i[
      id
      paging_token
      source_account
      type
      type_i
      created_at
      transaction_hash
      starting_balance
      funder
      account
      asset_type
      asset_code
      asset_issuer
      from
      to
      amount
    ].each do |attr|
      define_method :"default_#{attr}" do
        raw.to_hash[attr.to_s]
      end
    end
  end
end
