module StellarBase
  module DepositRequests
    class InitStellarRecipientAccount

      extend LightService::Action
      expects :deposit_request
      promises :recipient_account

      executed do |c|
        c.recipient_account = Stellar::Account
          .from_address(c.deposit_request.account_id)
      end

    end
  end
end
