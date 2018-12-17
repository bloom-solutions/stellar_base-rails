module StellarBase
  module WithdrawalRequests
    class FindWithdrawalRequest

      extend LightService::Action
      expects :stellar_operation
      promises :withdrawal_request

      MATCH_WITHDRAWAL_REQUEST_TO_STELLAR_TX_MAP = {
        memo_type: :memo_type,
        memo: :memo,
      }.freeze

      MATCH_WITHDRAWAL_REQUEST_TO_STELLAR_OP_MAP = {
        asset_code: :asset_code,
        issuer: :asset_issuer,
      }.freeze

      executed do |c|
        stellar_operation = c.stellar_operation
        stellar_transaction = stellar_operation.stellar_transaction

        c.withdrawal_request = withdrawal_request =
          WithdrawalRequest.find_by(memo: stellar_transaction.memo)

        if withdrawal_request.nil?
          c.skip_remaining!
          next c
        end

        tx_map = MATCH_WITHDRAWAL_REQUEST_TO_STELLAR_TX_MAP
        mismatch_tx = tx_map.any? do |withdrawal_request_attr, stellar_tx_attr|
          withdrawal_request.send(withdrawal_request_attr) !=
            stellar_transaction.send(stellar_tx_attr)
        end

        op_map = MATCH_WITHDRAWAL_REQUEST_TO_STELLAR_OP_MAP
        mismatch_op = op_map.any? do |withdrawal_request_attr, stellar_op_attr|
          withdrawal_request.send(withdrawal_request_attr) !=
            stellar_operation.send(stellar_op_attr)
        end

        if [mismatch_tx, mismatch_op].any?
          c.skip_remaining!
          next c
        end
      end

    end
  end
end
