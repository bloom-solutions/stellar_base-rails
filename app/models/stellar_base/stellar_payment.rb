module StellarBase
  class StellarPayment < StellarOperation

    store_attributes :data do
      amount BigDecimal
      asset_code String
      asset_issuer Boolean
      asset_type String
      from String
      to String
    end

  end
end
