module StellarBase
  module WithdrawalRequests
    class DetermineFee

      DEFAULT = 0.0
      # NOTE: Hard-code default network fees for now.
      DEFAULT_NETWORK = {
        bitcoin: 0.0001,
      }.with_indifferent_access.freeze

      def self.call(v)
        v || DEFAULT
      end

      def self.network(network, v)
        v || DEFAULT_NETWORK.fetch(network)
      end

    end
  end
end
