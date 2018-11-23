module StellarBase
  class Balance

    include Virtus.model

    attribute :asset_code, String
    attribute :amount, BigDecimal

    def self.find(asset_code)
      asset = FindWithdrawableAsset.(asset_code)

      amount = DetermineMaxAmount.(asset[:max_amount_from])
      new(asset_code: asset_code, amount: amount)
    end

  end
end
