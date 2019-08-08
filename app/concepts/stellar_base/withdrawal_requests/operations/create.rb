module StellarBase
  module WithdrawalRequests
    module Operations
      class Create < ApplicationOperation

        DEFAULT_ETA = (10 * 60).freeze
        POLICY_ERROR_MESSAGE = "You are unauthorized to request withdrawal details"

        step self::Policy::Pundit(WithdrawalRequestPolicy, :create?)
        failure :set_policy_error!
        step Model(WithdrawalRequest, :new)
        step :setup_params!
        step :find_withdrawal_asset_details!
        step :set_fee_fixed!
        step Contract::Build(constant: Contracts::Create)
        step Contract::Validate(key: :withdrawal_request)
        step Contract::Persist(method: :sync)
        success :set_defaults!
        step Contract::Persist(method: :save)

        private

        def set_policy_error!(options, params:, **)
          options["result.policy.message"] = POLICY_ERROR_MESSAGE
        end

        def setup_params!(options, params:, **)
          params[:withdrawal_request].merge!({
            asset_type: params[:withdrawal_request][:type],
          })
        end

        def find_withdrawal_asset_details!(ctx, params:, **)
          asset_code = params[:withdrawal_request][:asset_code]
          details = FindWithdrawableAsset.(asset_code)
          ctx["asset_details"] = details.presence || {}
        end

        def set_fee_fixed!(ctx, params:, asset_details:, **)
          params[:withdrawal_request][:fee_fixed] =
            CallFeeFixedFrom.(params, asset_details)
        end

        def set_defaults!(options, params:, asset_details:, model:, **)
          model.issuer = asset_details[:issuer]
          model.account_id = StellarBase.configuration.distribution_account
          model.memo_type = "text"
          model.memo = GenMemoFor.(WithdrawalRequest)
          model.eta = DEFAULT_ETA
          model.min_amount = 0.0
          model.max_amount = DetermineMaxAmount.(asset_details[:max_amount_from])
          model.fee_percent = DetermineFee.(asset_details[:fee_percent])
        end

      end
    end
  end
end
