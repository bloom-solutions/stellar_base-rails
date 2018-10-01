module StellarBase
  module DepositRequests
    class FindDeposit

      extend LightService::Action

      expects :deposit_request, :tx_id
      promises :deposit

      executed do |c|
        c.deposit = Deposit.find_by(
          deposit_request_id: c.deposit_request.id,
          tx_id: c.tx_id,
        )

        c.skip_remaining! if c.deposit.present?
      end

    end
  end
end
