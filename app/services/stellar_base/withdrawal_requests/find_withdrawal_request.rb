module StellarBase
  module WithdrawalRequests
    class FindWithdrawalRequest

      extend LightService::Action
      expects :bridge_callback
      promises :withdrawal_request

      MATCH_WITHDRAWAL_REQUEST_TO_BRIDGE_CALLBACK_MAP = {
        asset_code: :asset_code,
        issuer: :asset_issuer,
        memo_type: :memo_type,
        memo: :memo,
      }.freeze

      executed do |c|
        bridge_callback = c.bridge_callback
        c.withdrawal_request = withdrawal_request = WithdrawalRequest.
          find_by(memo: bridge_callback.memo)

        if withdrawal_request.nil?
          c.skip_remaining!
          next c
        end

        map = MATCH_WITHDRAWAL_REQUEST_TO_BRIDGE_CALLBACK_MAP
        mismatch = map.any? do |withdrawal_request_attr, bridge_callback_attr|
          withdrawal_request.send(withdrawal_request_attr) !=
            bridge_callback.send(bridge_callback_attr)
        end

        if mismatch
          c.skip_remaining!
          next c
        end
      end

    end
  end
end
