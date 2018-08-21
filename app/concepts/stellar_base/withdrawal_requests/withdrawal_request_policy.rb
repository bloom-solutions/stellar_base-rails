module StellarBase
  module WithdrawalRequests
    class WithdrawalRequestPolicy

      def initialize(_, _)
      end

      def create?
        StellarBase.included_module?(:withdraw)
      end

    end
  end
end
