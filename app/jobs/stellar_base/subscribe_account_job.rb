module StellarBase
  class SubscribeAccountJob < ApplicationJob

    sidekiq_options retry: 0

    def perform(account_subscription_id)
      account_subscription = AccountSubscription.find(account_subscription_id)
      SubscribeAccount.(account_subscription)
    end

    def self.unique_args(args)
      args
    end

  end
end
