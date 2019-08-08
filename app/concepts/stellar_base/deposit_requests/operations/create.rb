module StellarBase
  module DepositRequests
    module Operations
      class Create < ApplicationOperation

        DEFAULT_ETA = (10 * 60).freeze

        step self::Policy::Pundit(DepositRequestPolicy, :create?)
        step Model(DepositRequest, :new)
        step :setup_params!
        step Contract::Build(constant: Contracts::Create)
        step Contract::Validate(key: :deposit_request)
        step Contract::Persist(method: :sync)
        step :find_depositable_asset_details!
        step :determine_how!
        step :determine_max_amount!
        success :set_defaults!
        step Contract::Persist(method: :save)

        private

        def setup_params!(options, params:, **)
          params[:deposit_request].merge!({
            account_id: params[:deposit_request][:account],
            deposit_type: params[:deposit_request][:type],
            memo: memo_from(params[:deposit_request]),
            memo_type: memo_type_from(params[:deposit_request]),
          })
        end

        def find_depositable_asset_details!(options, params:, **)
          details = FindDepositableAsset.(params[:deposit_request][:asset_code])
          params[:deposit_asset_details] = details.presence || {}
        end

        def determine_how!(options, params:, **)
          details = params[:deposit_asset_details]
          options["model"].deposit_address =
            DetermineHow.(details[:how_from], params[:deposit_request])
        end

        def determine_max_amount!(options, params:, **)
          details = params[:deposit_asset_details]
          options["model"].max_amount =
            ConfiguredClassRunner.(details[:max_amount_from]) || 0
        end

        def set_defaults!(options, params:, **)
          details = params[:deposit_asset_details]

          options["model"].asset_type = details[:type]
          options["model"].issuer = details[:issuer]
          options["model"].eta = DEFAULT_ETA
          options["model"].min_amount = 0.0

          # Make Deposits free unless we want it configured
          # TODO: this should come from `CallDepositFeeFrom.(params, details)`
          options["model"].fee_fixed = details[:fee_fixed] || 0.0
          options["model"].fee_percent = details[:fee_percent] || 0.0
        end

        def memo_type_from(params)
          return "text" if params[:memo_type].blank?
          params[:memo_type]
        end

        def memo_from(params)
          return GenMemoFor.(DepositRequest) if params[:memo].blank?
          params[:memo]
        end

      end
    end
  end
end
