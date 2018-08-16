module StellarBase
  module WithdrawalRequests
    class DetermineFee

      DEFAULT = 0.0
      DEFAULT_NETWORK = 0.0001

      def self.call(v)
        v || DEFAULT
      end

      def self.network(v)
        v || DEFAULT_NETWORK
      end

    end
  end
end
