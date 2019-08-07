module StellarBase
  module FeeRequests
    module Operations
      class Show < ApplicationOperation

        POLICY_ERROR_MESSAGE = "You are unauthorized to request fee details".freeze

        step self::Policy::Pundit(FeeRequestPolicy, :show?)
        failure :set_policy_error!
        step Model(FeeRequest, :new)
        step Contract::Build(constant: Contracts::Show)
        step Contract::Validate(key: :fee_request)
        step Contract::Persist(method: :sync)
        step :find_asset_details!
        success :set_fee_response!

        private

        def set_policy_error!(options, params:, **)
          options["result.policy.message"] = POLICY_ERROR_MESSAGE
        end

        def find_asset_details!(options, params:, **)
          details = FindAssetDetails.(
            operation: params[:fee_request][:operation],
            asset_code: params[:fee_request][:asset_code],
          )
          options[:asset_details] = details.presence || {}
        end

        def set_fee_response!(options, model:, asset_details:, params:, **)
          model.fee_response = FeeRequests::CallFeeFrom.(
            fee_request: model,
            fixed_fee_quote_from: asset_details[:fixed_fee_quote_from],
          )
        end

      end
    end
  end
end

