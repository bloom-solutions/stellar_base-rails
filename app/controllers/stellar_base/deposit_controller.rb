module StellarBase
  class DepositController < ApplicationController

    def create
      op = DepositRequests::Operations::Create.(deposit_request: params)

      respond_to do |f|
        f.json do
          if op.success?
            twin = DepositRequestTwin.new(op["model"])
            representer = DepositRequestRepresenter.new(twin)
            render json: representer
          else
            render(
              json: { error: op["contract.default"].errors },
              status: :unprocessable_entity,
            )
          end
        end
      end
    end

  end
end
