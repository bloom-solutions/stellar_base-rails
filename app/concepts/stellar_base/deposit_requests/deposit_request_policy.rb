module StellarBase
  module DepositRequests
    class DepositRequestPolicy

      def initialize(_, _)
      end

      def create?
        StellarBase.included_module?(:deposit)
      end

    end
  end
end
