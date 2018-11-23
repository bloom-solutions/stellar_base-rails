module StellarBase
  module Balances
    module Operations
      class Show < ApplicationOperation

        step self::Policy::Pundit(BalancesPolicy, :show?)
        failure :set_policy_error!
        step Model(Balance, :new)
        step Contract::Build(constant: Contracts::Create)
        step Contract::Validate(key: :balance)
        step Contract::Persist(method: :sync)
        step :find_asset_details!
        success :set_amount!

        private

        def set_policy_error!(options, params:, **)
          options["result.policy.message"] = "Not authorized to check balances"
        end

        def find_asset_details!(options, params:, **)
          details = WithdrawalRequests::FindWithdrawableAsset
            .(params[:balance][:asset_code])
          options[:asset_details] = details.presence || {}
        end

        def set_amount!(options, asset_details:, params:, **)
          options["model"].amount = WithdrawalRequests::DetermineMaxAmount
            .(asset_details[:max_amount_from])
        end

      end
    end
  end
end
