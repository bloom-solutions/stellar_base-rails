module StellarBase
  module DepositRequests
    class Trigger

      extend LightService::Organizer

      def self.call(network, deposit_address, tx_id, amount)
        with(
          network: network,
          deposit_address: deposit_address,
          tx_id: tx_id,
          amount: amount,
        ).reduce(actions)
      end

      def self.actions
        [
          FindConfig,
          FindDepositRequest,
          FindOrCreateDeposit,
          InitStellarClient,
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
