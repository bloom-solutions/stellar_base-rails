module StellarBase
  module WithdrawalRequests
    module Operations
      class Create < ApplicationOperation

        DEFAULT_ETA = (10 * 60).freeze

        step self::Policy::Pundit(WithdrawalRequestPolicy, :create?)
        step Model(WithdrawalRequest, :new)
        step :find_withdrawal_asset_details!
        success :set_defaults!
        step Contract::Build(constant: Contracts::Create)
        step Contract::Validate(key: :withdrawal_request)
        step Contract::Persist()

        private

        def find_withdrawal_asset_details!(options, params:, **)
          withdraw_config = StellarBase.configuration.withdraw
          details = withdraw_config.find do |e|
            e[:asset_code] == params[:withdrawal_request][:asset_code]
          end

          return Railway.fail_fast! if details.nil?

          options["withdrawal_asset_details"] = details
          return true
        end

        def set_defaults!(options, withdrawal_asset_details:, params:, **)
          network_fee = DetermineFee.network(
            withdrawal_asset_details[:network],
            params[:withdrawal_request][:fee_network],
          )
          params[:withdrawal_request].merge!({
            asset_type: params[:withdrawal_request][:type],
            issuer: withdrawal_asset_details[:issuer],
            account_id: StellarBase.configuration.distribution_account,
            memo_type: "text",
            memo: GenMemo.(),
            eta: DEFAULT_ETA,
            min_amount: 0.0,
            max_amount: nil,
            fee_fixed: DetermineFee.(withdrawal_asset_details[:fee_fixed]),
            fee_percent: DetermineFee.(withdrawal_asset_details[:fee_percent]),
            fee_network: network_fee,
          })
        end

      end
    end
  end
end
