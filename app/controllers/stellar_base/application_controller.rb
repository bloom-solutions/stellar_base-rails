module StellarBase
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session

    private

    def errors_from(op)
      unless op["result.policy.default"].success?
        return { error: op["result.policy.message"] }
      end

      if op["contract.default"].errors.any?
        return { error: op["contract.default"].errors }
      end
    end

  end
end
