module StellarBase
  module WithdrawalRequests
    class DetermineMaxAmount

      DEFAULT = nil

      def self.call(class_name)
        return DEFAULT if class_name.blank?
        GetCallbackFrom.(class_name).()
      end

    end
  end
end
