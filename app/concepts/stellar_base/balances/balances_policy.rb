module StellarBase
  module Balances
    class BalancesPolicy

      def initialize(_, _)
      end

      def show?
        StellarBase.included_module?(:balances) &&
          StellarBase.included_module?(:withdraw)
      end

    end
  end
end
