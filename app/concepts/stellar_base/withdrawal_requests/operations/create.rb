module StellarBase
  module WithdrawalRequests
    module Operations
      class Create < ApplicationOperation

        DEFAULT_ETA = (10 * 60).freeze

        step self::Policy::Pundit(WithdrawalRequestPolicy, :create?)
        step Model(WithdrawalRequest, :new)
        step :setup_params!
        step Contract::Build(constant: Contracts::Create)
        step Contract::Validate(key: :withdrawal_request)
        step Contract::Persist(method: :sync)
        step :find_withdrawal_asset_details!
        success :set_defaults!
        step Contract::Persist(method: :save)

        private

        def setup_params!(options, params:, **)
          params[:withdrawal_request].merge!({
            asset_type: params[:withdrawal_request][:type],
          })
        end

        def find_withdrawal_asset_details!(options, params:, **)
          details = FindWithdrawableAsset
            .(params[:withdrawal_request][:asset_code])
          params[:withdrawal_asset_details] = details.presence || {}
        end

        def set_defaults!(options, params:, **)
          withdrawal_asset_details = params[:withdrawal_asset_details]

          fee_network = DetermineFee.network(
            withdrawal_asset_details[:network],
            params[:withdrawal_request][:fee_network],
          )

          options["model"].issuer = withdrawal_asset_details[:issuer]
          options["model"].account_id =
            StellarBase.configuration.distribution_account
          options["model"].memo_type = "text"
          options["model"].memo = GenMemoFor.(WithdrawalRequest)
          options["model"].eta = DEFAULT_ETA
          options["model"].min_amount = 0.0
          options["model"].max_amount =
            DetermineMaxAmount.(withdrawal_asset_details[:max_amount_from])
          options["model"].fee_fixed =
            DetermineFee.(withdrawal_asset_details[:fee_fixed])
          options["model"].fee_percent =
            DetermineFee.(withdrawal_asset_details[:fee_percent])
          options["model"].fee_network = fee_network
        end

      end
    end
  end
end
