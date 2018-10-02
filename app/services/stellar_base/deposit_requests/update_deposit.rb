module StellarBase
  module DepositRequests
    class UpdateDeposit

      extend LightService::Action
      expects :stellar_tx_id, :deposit

      executed do |c|
        c.deposit.update!(stellar_tx_id: c.stellar_tx_id)
      end

    end
  end
end
