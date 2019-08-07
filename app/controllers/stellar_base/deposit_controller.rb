module StellarBase
  class DepositController < ApplicationController

    def create
      op = DepositRequests::Operations::Create
        .(deposit_request: deposit_params)

      respond_to do |f|
        f.json do
          if op.success?
            twin = DepositRequestTwin.new(op["model"])
            representer = DepositRequestRepresenter.new(twin)
            render json: representer
          else
            render json: errors_from(op), status: :unprocessable_entity
          end
        end
      end
    end

    private

    def deposit_params
      params.permit(
        :account,
        :asset_code,
        :memo,
        :memo_type,
        :type,
        :email_address,
      ).to_hash.with_indifferent_access
    end

  end
end
