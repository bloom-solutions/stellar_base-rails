module StellarBase
  module DepositRequests
    class SendAsset

      extend LightService::Action
      expects(
        :deposit_request,
        :distribution_account,
        :issuer_account,
        :recipient_account,
        :stellar_amount,
        :asset_sending_client,
      )
      promises :stellar_tx_id

      executed do |c|
        msg = [
          "issuing account: #{c.issuer_account.address}",
          "recipient account: #{c.recipient_account.address}",
          "stellar amount: #{c.stellar_amount.amount}#{c.stellar_amount.asset}",
          "distribution account: #{c.distribution_account.address}",
          "recipient memo: #{c.deposit_request.memo}",
        ].join("; ")

        Rails.logger.info(msg)

        begin
          response = c.asset_sending_client.send_payment(
            from: c.distribution_account,
            to: c.recipient_account,
            amount: c.stellar_amount,
            memo: c.deposit_request.memo,
          )

          c.stellar_tx_id = response.to_hash["hash"]
        rescue Faraday::ClientError => e
          c.fail_and_return! "Error sending the asset. " \
            "Faraday::ClientError: #{e.inspect}"
        end
      end

    end
  end
end
