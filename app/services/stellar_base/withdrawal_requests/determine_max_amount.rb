module StellarBase
  module WithdrawalRequests
    class DetermineMaxAmount

      DEFAULT = nil

      def self.call(class_name)
        return class_name.constantize.send(:call) if class_name.present?
        DEFAULT
      end

    end
  end
end
