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

    def verify_mac_payload
      callback_mac_payload = request.headers["HTTP_X_PAYLOAD_MAC"]

      result = BridgeCallbacks::VerifyMacPayload.execute(
        callback_params: callback_params,
        callback_mac_payload: callback_mac_payload,
      )

      if result.failure?
        log_unsuccessful_callback result.message
        head :bad_request
      end
    end

  end
end
