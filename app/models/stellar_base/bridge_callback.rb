module StellarBase
  class BridgeCallback
    include Virtus.model
    # Attributes and params from
    # https://github.com/stellar/bridge-server/blob/master/readme_bridge.md#callbacksreceive
    attribute :id, String
    attribute :from, String
    attribute :route, String
    attribute :amount, Float
    attribute :asset_code, String
    attribute :asset_issuer, String
    attribute :memo_type, String
    attribute :memo, String
    attribute :data, String
    attribute :transaction_id, String
  end
end
