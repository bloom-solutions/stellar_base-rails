module StellarBase
  class BalancesController < ApplicationController

    def show
      op = Balances::Operations::Show.(balance: balance_params)

      respond_to do |f|
        f.json do
          if op.success?
            representer = BalanceRepresenter.new(op["model"])
            render json: representer
          else
            render(
              json: errors_from(op),
              status: :unprocessable_entity,
            )
          end
        end
      end
    end

    private

    def balance_params
      params.permit(:asset_code).to_hash.with_indifferent_access
    end

  end
end
