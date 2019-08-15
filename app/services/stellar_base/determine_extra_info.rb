module StellarBase
  class DetermineExtraInfo

    def self.call(asset_details)
      info_from =
        GetCallbackFrom.(asset_details[:extra_info_from])

      if info_from
        return info_from.(asset_details)
      end
    end

  end
end
