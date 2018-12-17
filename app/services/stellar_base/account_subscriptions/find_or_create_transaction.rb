module StellarBase
  module AccountSubscriptions
    class FindOrCreateTransaction

      extend LightService::Action
      expects :remote_transaction
      promises :stellar_transaction

      executed do |c|
        remote_transaction = c.remote_transaction

        c.stellar_transaction = StellarTransaction.
          find_by(transaction_id: remote_transaction["id"])

        next c if c.stellar_transaction.present?

        c.stellar_transaction = StellarTransaction.create!(
          transaction_id: remote_transaction["id"],
          memo: remote_transaction["memo"],
          memo_type: remote_transaction["memo_type"],
        )
      end

    end
  end
end
