module StellarBase
  module FeeRequests
    class CallFeeFrom

      FEE_FROM_ERROR = "`fee_from` must be a string of an object " \
        "that responds to `.call` or the object itself".freeze

      def self.call(fee_request:, fee_from:)
        return 0 if fee_from.nil?
        callback = callback_from(fee_from)
        callback.(fee_request)
      end

      def self.callback_from(fee_from)
        if fee_from.respond_to?(:constantize)
          fee_from = fee_from.constantize
        end

        if !fee_from.respond_to?(:call)
          fail ArgumentError, FEE_FROM_ERROR
        end

        fee_from
      end

    end
  end
end
