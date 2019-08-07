module StellarBase
  module FeeRequests
    class CallFeeFrom

      FIXED_FEE_QUOTE_FROM_ERROR = "`fixed_fee_quote_from` must be a string of an object " \
        "that responds to `.call` or the object itself".freeze

      def self.call(fee_request:, fixed_fee_quote_from:)
        return 0 if fixed_fee_quote_from.nil?
        callback = callback_from(fixed_fee_quote_from)
        callback.(fee_request)
      end

      def self.callback_from(fixed_fee_quote_from)
        if fixed_fee_quote_from.respond_to?(:constantize)
          fixed_fee_quote_from = fixed_fee_quote_from.constantize
        end

        if !fixed_fee_quote_from.respond_to?(:call)
          fail ArgumentError, FIXED_FEE_QUOTE_FROM_ERROR
        end

        fixed_fee_quote_from
      end

    end
  end
end
