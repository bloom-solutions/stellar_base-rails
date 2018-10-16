module StellarBase
  class WithdrawController < ApplicationController

    def create
      op = WithdrawalRequests::Operations::Create
        .(withdrawal_request: withdraw_params)

      respond_to do |f|
        f.json do
          if op.success?
            twin = WithdrawalRequestTwin.new(op["model"])
            representer = WithdrawalRequestRepresenter.new(twin)
            render json: representer
          else
            render(
              json: { error: op["result.policy.message"] || op["contract.default"].errors },
              status: :unprocessable_entity,
            )
          end
        end
      end
    end

    private

    def withdraw_params
      params.permit(
        :asset_code,
        :dest,
        :dest_extra,
        :fee_network,
        :type,
      ).to_hash.with_indifferent_access
    end

  end
end
