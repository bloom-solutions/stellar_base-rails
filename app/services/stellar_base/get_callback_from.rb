module StellarBase
  class GetCallbackFrom

    def self.call(callback)
      if callback.respond_to?(:constantize)
        callback = callback.constantize
      end

      callback
    end

  end
end
