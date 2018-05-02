module StellarBase
  module BridgeCallbacks
    module Contracts
      class Process < ApplicationContract

        property :id
        property :from
        property :route
        property :amount
        property :asset_code
        property :asset_issuer
        property :memo_type
        property :memo
        property :data
        property :transaction_id

      end
    end
  end
end
