require 'spec_helper'

module StellarBase
  RSpec.describe EnqueueSubscribeAccountsJob do

    let!(:account_subscription) do
      create(:stellar_base_account_subscription, address: "GABC")
    end

    it "creates AccountSubscription records for the hard-coded accounts then enqueues a job for each AccountSubscription" do
      StellarBase.configuration.subscribe_to_accounts = %w(GB)

      described_class.new.perform

      new_account = AccountSubscription.find_by(address: "GB")

      expect(new_account).to be_present
      [new_account, account_subscription].each do |acc|
        expect(SubscribeAccountJob).to have_enqueued_sidekiq_job(acc.id)
      end
    end

  end
end
