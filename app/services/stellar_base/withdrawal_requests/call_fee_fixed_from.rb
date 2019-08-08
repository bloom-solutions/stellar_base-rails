module StellarBase
  module WithdrawalRequests
    class CallFeeFixedFrom

      CALLBACK_CONFIG_NAME = :fee_fixed_from
      INVALID_FEE_MESSAGE =
        "`fee_fixed_from` must return a value >= 0".freeze

      def self.call(params, asset_details)
        if fee_fixed = asset_details[:fee_fixed]
          return fee_fixed
        end

        callback = GetCallbackFrom.(asset_details[CALLBACK_CONFIG_NAME])

        return 0.0 if callback.nil?

        fee_fixed = callback.(params, asset_details)

        if fee_fixed.nil?
          fail ArgumentError, INVALID_FEE_MESSAGE
        end

        fee_fixed
      end

    end
  end
end
