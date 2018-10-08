module StellarBase
  class SubscribeAccount

    extend LightService::Organizer
    OPERATION_LIMIT = 200

    def self.call(account_subscription, operation_limit: OPERATION_LIMIT)
      with(
        account_subscription: account_subscription,
        operation_limit: operation_limit,
      ).reduce(actions)
    end

    def self.actions
      [
        InitStellarClient,
        AccountSubscriptions::GetCursor,
        AccountSubscriptions::GetOperations,
        iterate(:operations, [
          AccountSubscriptions::GetTx,
          AccountSubscriptions::ExecuteCallback,
          AccountSubscriptions::SaveCursor,
        ]),
      ]
    end

  end
end
