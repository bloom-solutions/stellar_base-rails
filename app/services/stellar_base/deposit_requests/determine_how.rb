module StellarBase
  module DepositRequests
    class DetermineHow

      DEFAULT = nil

      def self.call(class_name, params)
        # TODO: how do we handle errors
        return class_name.constantize.send(:call, params) if class_name.present?
        DEFAULT
      end

    end
  end
end
