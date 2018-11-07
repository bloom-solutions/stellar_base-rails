module StellarBase
  module DepositRequests
    class FindOrCreateDeposit

      extend LightService::Action

      expects :deposit_request, :tx_id, :amount
      promises :deposit

      executed do |c|
        c.deposit = Deposit.find_or_create_by(
          deposit_request_id: c.deposit_request.id,
          tx_id: c.tx_id,
        ) do |deposit|
          deposit.amount = c.amount
        end

        stellar_tx_id = c.deposit.stellar_tx_id

        if stellar_tx_id.present?
          c.skip_remaining! "Deposit previously made: stellar_tx_id " \
            "#{stellar_tx_id}, skipping"
        end
      end

    end
  end
end
