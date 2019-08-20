module StellarBase
  module DepositRequests
    class DetermineEta

      DEFAULT = nil

      def self.call(class_name, params)
        # TODO: how do we handle errors
        if class_name.present?
          callback = GetCallbackFrom.(class_name)
          unless callback.method(:call).arity.zero?
            return callback.send(:call, params)
          end

          return callback.send(:call)
        end
        DEFAULT
      end

    end
  end
end
