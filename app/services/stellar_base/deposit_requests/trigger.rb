module StellarBase
  module DepositRequests
    class Trigger

      extend LightService::Organizer

      def self.call(
        network,
        deposit_address,
        tx_id,
        amount,
        horizon_url: StellarBase.configuration.horizon_url,
        sending_strategy: StellarBase.configuration.sending_strategy
      )
        with(
          network: network,
          deposit_address: deposit_address,
          tx_id: tx_id,
          amount: amount,
          horizon_url: horizon_url,
          sending_strategy: sending_strategy,
        ).reduce(actions)
      end

      def self.actions
        [
          FindConfig,
          FindDepositRequest,
          FindOrCreateDeposit,
          InitAssetSendingClient,
          InitStellarIssuerAccount,
          InitStellarRecipientAccount,
          InitStellarDistributionAccount,
          InitStellarAsset,
          InitStellarAmount,
          SendAsset,
          UpdateDeposit,
        ]
      end

    end
  end
end
