module StellarBase
  module AccountSubscriptions
    class FindOrCreateOperation

      extend LightService::Action
      expects :remote_operation
      promises :stellar_operation

      SUPPORTED_TYPES = %w(payment).freeze

      executed do |c|
        remote_operation = c.remote_operation

        c.stellar_operation = StellarOperation.
          find_by(operation_id: remote_operation["id"])

        next c if c.stellar_operation.present?

        if SUPPORTED_TYPES.include?(remote_operation["type"])
          klass = StellarBase.
            const_get("stellar_#{remote_operation["type"]}".classify)
          c.stellar_operation = klass.create!(
            operation_id: remote_operation["id"],
            transaction_hash: remote_operation["transaction_hash"],
            asset_code: remote_operation["asset_code"],
            asset_issuer: remote_operation["asset_issuer"],
            from: remote_operation["from"],
            to: remote_operation["to"],
            amount: remote_operation["amount"],
          )
        else
          c.stellar_operation = StellarOperation.create!(
            operation_id: remote_operation["id"],
            transaction_hash: remote_operation["transaction_hash"],
          )
        end

      end

    end
  end
end
