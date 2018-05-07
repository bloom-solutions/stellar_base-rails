module StellarBase
  class BridgeCallbacksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      op = BridgeCallbacks::Operations::Process.(bridge_callback: callback_params)

      respond_to do |f|
        f.json do
          if op.success?
            head :ok
          else
            log_unsuccessful_callback(op)
            head :unprocessable_entity
          end
        end
      end
    end

    private

    def log_unsuccessful_callback(op)
      Rails.logger.warn("Unsuccessful bridge callback #{callback_params.to_s}")

      error_messages = op["contract.default"].errors.full_messages
      Rails.logger.warn("Details: #{error_messages}")
    end

    def callback_params
      params.permit(
        :id,
        :from,
        :route,
        :amount,
        :asset_code,
        :asset_issuer,
        :memo_type,
        :memo,
        :data,
        :transaction_id,
      )
    end
  end
end
