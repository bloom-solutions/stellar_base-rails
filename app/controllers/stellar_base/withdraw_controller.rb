module StellarBase
  class WithdrawController < ApplicationController

    WITHDRAWAL_REQUEST_PARAMS = %i[
      type
      asset_code
      dest
      dest_extra
    ]

    def create
      op = WithdrawalRequests::Operations::Create.(withdrawal_request: withdrawal_request_params)

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

    def withdrawal_request_params
      params.permit(*WITHDRAWAL_REQUEST_PARAMS)
    end

  end
end
