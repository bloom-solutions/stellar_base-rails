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

    def errors_from(op)
      unless op["result.policy.default"].success?
        return { errors: op["result.policy.message"] }
      end

      if op["contract.default"].errors.any?
        return { errors: op["contract.default"].errors }
      end
    end

    def balance_params
      params.permit(:asset_code).to_hash.with_indifferent_access
    end

  end
end
