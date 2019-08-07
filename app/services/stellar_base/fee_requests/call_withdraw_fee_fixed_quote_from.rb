module StellarBase
  module FeeRequests
    class CallWithdrawFeeFixedQuoteFrom

      FEE_FIXED_QUOTE_FROM_ERROR = "`fee_fixed_quote_from` must be a string of an object " \
        "that responds to `.call` or the object itself".freeze

      def self.call(fee_request:, fee_fixed_quote_from:)
        asset_details = asset_details_from(fee_request)

        if fee = asset_details[:fee_fixed]
          return fee
        end

        return 0.0 if fee_fixed_quote_from.nil?

        callback = callback_from(fee_fixed_quote_from)
        callback.(fee_request)
      end

      def self.callback_from(fee_fixed_quote_from)
        if fee_fixed_quote_from.respond_to?(:constantize)
          fee_fixed_quote_from = fee_fixed_quote_from.constantize
        end

        if !fee_fixed_quote_from.respond_to?(:call)
          fail ArgumentError, FEE_FIXED_QUOTE_FROM_ERROR
        end

        fee_fixed_quote_from
      end

      private

      def self.asset_details_from(fee_request)
        FindAssetDetails.(
          operation: "withdraw",
          asset_code: fee_request.asset_code,
        )
      end

    end
  end
end
