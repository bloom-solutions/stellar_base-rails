module StellarBase
  class FeeRequest

    include Virtus.model

    attribute :operation, String
    attribute :amount, BigDecimal
    attribute :asset_code, BigDecimal
    attribute :type, String
    attribute :fee_response, BigDecimal

  end
end
