module StellarBase
  module DepositRequests
    class InitStellarAmount

      extend LightService::Action
      expects :stellar_asset, :amount
      promises :stellar_amount

      executed do |c|
        c.stellar_amount = Stellar::Amount.new(c.amount, c.stellar_asset)
      end

    end
  end
end
