module StellarBase
  module DepositRequests
    class FindDepositRequest

      extend LightService::Action

      expects :deposit_config, :deposit_address
      promises :deposit_request

      executed do |c|
        deposit_address = c.deposit_address
        asset_code = c.deposit_config[:asset_code]

        c.deposit_request = DepositRequest.find_by(
          deposit_address: deposit_address,
          asset_code: asset_code,
        )

        if c.deposit_request.blank?
          c.skip_remaining! "No DepositRequest found for " +
            [asset_code, deposit_address].join(":")
        end
      end

    end
  end
end
