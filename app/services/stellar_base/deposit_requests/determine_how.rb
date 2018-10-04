module StellarBase
  module DepositRequests
    class DetermineHow

      DEFAULT = nil

      def self.call(class_name, params)
        # TODO: how do we handle errors
        if class_name.present?
          unless class_name.constantize.method(:call).arity.zero?
            return class_name.constantize.send(:call, params)
          end

          return class_name.constantize.send(:call)
        end
        DEFAULT
      end

    end
  end
end
