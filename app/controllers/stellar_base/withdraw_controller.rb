module StellarBase
  class WithdrawController < ApplicationController

    def create
      op = WithdrawalRequests::Operations::Create.(withdrawal_request: params)

      respond_to do |f|
        f.json do
          if op.success?
            twin = WithdrawalRequestTwin.new(op["model"])
            representer = WithdrawalRequestRepresenter.new(twin)
            render json: representer
          else
            render json: {error: op["contract.default"].errors}, status: :unprocessable_entity
          end
        end
      end
    end

  end
end
