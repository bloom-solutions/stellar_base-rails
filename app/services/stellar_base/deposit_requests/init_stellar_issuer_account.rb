module StellarBase
  module DepositRequests
    class InitStellarIssuerAccount

      extend LightService::Action
      expects :deposit_config
      promises :issuer_account

      executed do |c|
        config = c.deposit_config
        c.issuer_account = Stellar::Account.from_address(config[:issuer])
      end

    end
  end
end
