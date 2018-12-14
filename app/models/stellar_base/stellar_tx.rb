module StellarBase
  class StellarTx

    include Virtus.model
    attribute :raw, Object#, default: :default_raw, lazy: true
    attribute :id, String, default: :default_id, lazy: true
    attribute :paging_token, String, default: :default_paging_token, lazy: true
    attribute :ledger, Integer, default: :default_ledger, lazy: true
    attribute :created_at, DateTime, default: :default_created_at, lazy: true
    attribute :source_account, String, default: :default_source_account, lazy: true
    attribute :source_account_sequence, String, default: :default_source_account_sequence, lazy: true
    attribute :fee_paid, Integer, default: :default_fee_paid, lazy: true
    attribute :operation_count, Integer, default: :default_operation_count, lazy: true
    attribute :envelope_xdr, String, default: :default_envelope_xdr, lazy: true
    attribute :result_xdr, String, default: :default_result_xdr, lazy: true
    attribute :result_meta_xdr, String, default: :default_result_meta_xdr, lazy: true
    attribute :fee_meta_xdr, String, default: :default_fee_meta_xdr, lazy: true
    attribute :memo_type, String, default: :default_memo_type, lazy: true
    attribute :memo, String, default: :default_memo, lazy: true
    attribute :signatures, Array, default: :default_signatures, lazy: true
    attribute :valid_after, DateTime, default: :default_valid_after, lazy: true

    private

    %i[
      id
      paging_token
      ledger
      created_at
      source_account
      source_account_sequence
      fee_paid
      operation_count
      envelope_xdr
      result_xdr
      result_meta_xdr
      fee_meta_xdr
      memo_type
      memo
      signatures
      valid_after
    ].each do |attr|
      define_method :"default_#{attr}" do
        raw.to_hash[attr.to_s]
      end
    end

  end
end
