module StellarBase
  class StellarToml

    include Virtus.model

    attribute :ACCOUNTS, Array
    attribute :AUTH_SERVER, String
    attribute :CURRENCIES, Array
    attribute :DESIRED_BASE_FEE, Integer
    attribute :DESIRED_MAX_TX_PER_LEDGER, Integer
    attribute :FEDERATION_SERVER, String
    attribute :HISTORY, Array
    attribute :KNOWN_PEERS, Array
    attribute :NODE_NAMES, Array
    attribute :OUR_VALIDATORS, Array
    attribute :QUORUM_SET, Array
    attribute :SIGNING_KEY, String
    attribute :TRANSFER_SERVER, String

    ATTRIBUTES = %w[
      ACCOUNTS
      AUTH_SERVER
      CURRENCIES
      DESIRED_BASE_FEE
      DESIRED_MAX_TX_PER_LEDGER
      FEDERATION_SERVER
      HISTORY
      KNOWN_PEERS
      NODE_NAMES
      OUR_VALIDATORS
      QUORUM_SET
      SIGNING_KEY
      TRANSFER_SERVER
    ].freeze

    def to_hash
      ATTRIBUTES.each_with_object({}) do |attr, hash|
        value = send(attr)
        hash[attr] = send(attr) if value.present?
      end
    end

  end
end
