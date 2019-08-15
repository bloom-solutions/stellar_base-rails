module StellarBase
  class DepositRequestRepresenter < ApplicationRepresenter

    property :deposit_address, as: :how
    property :eta
    property :min_amount
    property :max_amount
    property :fee_fixed
    property :fee_percent
    property :extra_info, exec_context: :decorator

    def extra_info
      ::JSON.parse(represented.extra_info)
    rescue
      {}
    end

  end
end
