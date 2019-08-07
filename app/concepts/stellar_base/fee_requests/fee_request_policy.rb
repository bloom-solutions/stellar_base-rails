module StellarBase
  module FeeRequests
    class FeeRequestPolicy

      def initialize(_, _)
      end

      def show?
        StellarBase.included_module?(:fees) &&
          (
            StellarBase.included_module?(:withdraw) ||
              StellarBase.included_module?(:deposit)
          )
      end

    end
  end
end
