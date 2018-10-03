module StellarBase
  class EnqueueSubscribeAccountsJob < ApplicationJob

    extend LightService::Organizer

    def perform
      StellarBase.configuration.subscribe_to_accounts.each do |address|
        AccountSubscription.where(address: address).first_or_create!
      end

      AccountSubscription.find_each do |account_subscription|
        SubscribeAccountJob.perform_async(account_subscription.id)
      end
    end

  end
end
