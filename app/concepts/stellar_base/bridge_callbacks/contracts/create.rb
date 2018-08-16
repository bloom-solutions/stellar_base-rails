module StellarBase
  module BridgeCallbacks
    module Contracts
      class Create < ApplicationContract

        property :operation_id
        property :from
        property :route
        property :amount
        property :asset_code
        property :asset_issuer
        property :memo_type
        property :memo
        property :data
        property :transaction_id

        validates :operation_id, presence: true
        validates :transaction_id, presence: true
        validates :from, presence: true
        validates :amount, presence: true

      end
    end
  end
end
