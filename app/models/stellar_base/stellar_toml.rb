module StellarBase
  class StellarToml

    include Virtus.model

    attribute(:TRANSFER_SERVER, String, {
      lazy: true, default: :default_transfer_server
    })

    def default_transfer_server
      return "" unless StellarBase.included_module?(:withdraw)
      StellarBase::Engine.routes.url_helpers.withdraw_url
    end

  end
end
