module StellarBase
  class BridgeCallbacksController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :verify_mac_payload, if: :check_mac_payload?

    def create
      op = BridgeCallbacks::Operations::Process.(bridge_callback: callback_params)

      respond_to do |f|
        f.json do
          if op.success?
            head :ok
          else
            contract = op["contract.default"]
            log_unsuccessful_callback(contract.errors.full_messages)

            head :unprocessable_entity
          end
        end
      end
    end

    private

    def check_mac_payload?
      StellarBase.configuration.check_bridge_callbacks_mac_payload
    end

    def log_unsuccessful_callback(error_message)
      Rails.logger.warn("Unsuccessful bridge callback #{callback_params.to_s}")
      Rails.logger.warn("Details: #{error_message}")
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

      result = BridgeCallbacks::VerifyMacPayload.(
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
