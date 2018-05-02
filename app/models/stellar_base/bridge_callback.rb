module StellarBase
  class BridgeCallback < ApplicationDataModel
    # Attributes and params from
    # https://github.com/stellar/bridge-server/blob/master/readme_bridge.md#callbacksreceive
    attribute :id, DryTypes::String.optional
    attribute :from, DryTypes::String.optional
    attribute :route, DryTypes::String.optional
    attribute :amount, DryTypes::Decimal.optional
    attribute :asset_code, DryTypes::String.optional
    attribute :asset_issuer, DryTypes::String.optional
    attribute :memo_type, DryTypes::String.optional
    attribute :memo, DryTypes::String.optional
    attribute :data, DryTypes::String.optional
    attribute :transaction_id, DryTypes::String.optional

    attr_writer :id
    attr_writer :from
    attr_writer :route
    attr_writer :amount
    attr_writer :asset_code
    attr_writer :asset_issuer
    attr_writer :memo_type
    attr_writer :memo
    attr_writer :data
    attr_writer :transaction_id
  end
end
