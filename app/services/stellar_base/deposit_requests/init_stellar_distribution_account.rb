module StellarBase
  module DepositRequests
    class InitStellarDistributionAccount

      extend LightService::Action
      expects :deposit_config
      promises :distribution_account

      executed do |c|
        config = c.deposit_config
        c.distribution_account = Stellar::Account
          .from_seed(config[:distributor_seed])
      end

    end
  end
end
