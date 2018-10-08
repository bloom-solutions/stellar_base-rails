module StellarBase
  class SubscribeAccount

    extend LightService::Organizer
    OPERATION_LIMIT = 200

    def self.call(account_subscription, operation_limit: OPERATION_LIMIT)
      result = with(
        account_subscription: account_subscription,
        operation_limit: operation_limit,
      ).reduce(actions)

      Rails.logger.warn result.message if result.failure?
      result
    end

    def self.actions
      [
        InitStellarClient,
        AccountSubscriptions::GetCursor,
        AccountSubscriptions::GetOperations,
        iterate(:operations, [
          AccountSubscriptions::GetTx,
          AccountSubscriptions::ExecuteCallback,
        ]),
        AccountSubscriptions::SaveCursor,
      ]
    end

  end
end
