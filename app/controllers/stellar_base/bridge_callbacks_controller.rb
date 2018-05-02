module StellarBase
  class BridgeCallbacksController < ApplicationController
    def create
      op = BridgeCallbacks::Operations::Process.(bridge_callback: callback_params)

      respond_to do |f|
        f.json do
          if op.success?
            head :ok
          else
            head :unprocessable_entity
          end
        end
      end
    end

    private

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
