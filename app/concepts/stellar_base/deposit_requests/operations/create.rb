module StellarBase
  module DepositRequests
    module Operations
      class Create < ApplicationOperation

        step self::Policy::Pundit(DepositRequestPolicy, :create?)
        step Model(DepositRequest, :new)
        step :find_depositable_asset_details!
        step :setup_params!
        step :set_extra_info!
        step Contract::Build(constant: Contracts::Create)
        step Contract::Validate(key: :deposit_request)
        step Contract::Persist(method: :sync)
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
          options[:asset_details] = details.presence || {}
        end

        def determine_how!(options, params:, asset_details:, model:, **)
          model.deposit_address =
            DetermineHow.(asset_details[:how_from], params[:deposit_request])
        end

        def set_extra_info!(ctx, params:, asset_details:, **)
          params[:deposit_request][:extra_info] =
            DetermineExtraInfo.(asset_details).to_json
        end

        def determine_max_amount!(options, params:, asset_details:, model:, **)
          model.max_amount =
            ConfiguredClassRunner.(asset_details[:max_amount_from]) || 0
        end

        def set_defaults!(options, params:, model:, asset_details:, **)
          model.asset_type = asset_details[:type]
          model.issuer = asset_details[:issuer]
          model.eta =
            DetermineEta.(asset_details[:eta_from], params[:deposit_request])
          model.min_amount = 0.0

          # Make Deposits free unless we want it configured
          # TODO: this should come from `CallDepositFeeFrom.(params, asset_details)`
          model.fee_fixed = asset_details[:fee_fixed] || 0.0
          model.fee_percent = asset_details[:fee_percent] || 0.0
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
