module StellarBase
  class SubscribeAccount

    extend LightService::Organizer
    OPERATION_LIMIT = 200

    def self.call(
      account_subscription,
      operation_limit: OPERATION_LIMIT,
      on_account_event: StellarBase.configuration.on_account_event
    )
      result = with(
        account_subscription: account_subscription,
        operation_limit: operation_limit,
        on_account_event: on_account_event,
      ).reduce(actions)

      Rails.logger.warn result.message if result.failure?
      result
    end

    def self.actions
      [
        InitStellarClient,
        AccountSubscriptions::GetCursor,
        AccountSubscriptions::GetRemoteOperations,
        iterate(:remote_operations, [
          AccountSubscriptions::GetRemoteTransaction,
          AccountSubscriptions::FindOrCreateTransaction,
          AccountSubscriptions::FindOrCreateOperation,
          AccountSubscriptions::ExecuteAccountSubscriptionCallback,
        ]),
        AccountSubscriptions::SaveCursor,
      ]
    end

  end
end
