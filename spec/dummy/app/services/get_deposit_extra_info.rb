class GetDepositExtraInfo

  def self.call(asset_details)
    { some: "hash", asset_code: asset_details[:asset_code] }
  end

end
