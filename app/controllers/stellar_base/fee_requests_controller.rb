module StellarBase
  class FeeRequestsController < ApplicationController

    def show
      op = FeeRequests::Operations::Show.(fee_request: fee_request_params)

      respond_to do |f|
        f.json do
          if op.success?
            representer = FeeRequestRepresenter.new(op["model"])
            render json: representer
          else
            render json: errors_from(op), status: :unprocessable_entity
          end
        end
      end
    end

    private

    def fee_request_params
      params.permit(*%i[
        asset_code
        amount
        type
        operation
      ]).to_hash.with_indifferent_access
    end

  end
end
