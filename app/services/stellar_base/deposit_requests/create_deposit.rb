module StellarBase
  module DepositRequests
    class CreateDeposit

      extend LightService::Action

      expects :deposit_request, :tx_id, :amount
      promises :deposit

      executed do |c|
        deposit_request_id = c.deposit_request.id
        tx_id = c.tx_id

        deposit = Deposit.find_by(
          deposit_request_id: deposit_request_id,
          tx_id: tx_id,
        )

        if deposit.present?
          c.deposit = deposit
          c.fail_and_return! "Deposit already created for tx #{tx_id}"
        end

        c.deposit = Deposit.create(
          deposit_request_id: deposit_request_id,
          tx_id: tx_id,
          amount: c.amount,
        )
      end

    end
  end
end
