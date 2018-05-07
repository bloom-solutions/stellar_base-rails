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

        validates :id, presence: true
        validates :transaction_id, presence: true
        validates :from, presence: true
        validates :amount, presence: true

        validate :check_callback_authenticity

        def check_callback_authenticity
          if !StellarBase.configuration.check_bridge_callbacks_authenticity
            return
          end

          result = BridgeCallbacks::Check.({
            operation_id: id,
            transaction_id: transaction_id,
            params: {
              id: id,
              from: from,
              route: route,
              amount: amount,
              asset_code: asset_code,
              asset_issuer: asset_issuer,
              memo: memo,
              memo_type: memo_type,
              data: data,
              transaction_id: transaction_id,
            },
          })

          errors.add(:base, result.message) if result.failure?
        end

      end
    end
  end
end
