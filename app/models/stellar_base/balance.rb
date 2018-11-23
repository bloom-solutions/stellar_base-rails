module StellarBase
  class Balance

    include Virtus.model

    attribute :asset_code, String
    attribute :amount, BigDecimal

  end
end
