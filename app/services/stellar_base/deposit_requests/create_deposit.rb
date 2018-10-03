module StellarBase
  module DepositRequests
    class CreateDeposit

      extend LightService::Action
      expects :tx_id, :amount, :deposit_request
      promises :deposit

      executed do |c|
        c.deposit = Deposit.create!(
          tx_id: c.tx_id,
          amount: c.amount,
          deposit_request_id: c.deposit_request.id,
        )
      end

    end
  end
end
