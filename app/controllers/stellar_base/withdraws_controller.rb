module StellarBase
  class WithdrawsController < ApplicationController

    # TODO: 
    # This operation allows a user to redeem an asset currently on the Stellar 
    # network for the real asset (BTC, USD, stock, etc...) via the anchor of the 
    # Stellar asset. 
    #
    # Accepts:
    # type        - string (eg. 'crypto')
    # access_code - string (eg. BTC, ETH)
    def show
      render json: { message: "get withdraw information" }, status: :ok
    end

  end
end
