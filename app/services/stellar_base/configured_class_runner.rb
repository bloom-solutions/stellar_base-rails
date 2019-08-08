module StellarBase
  class ConfiguredClassRunner

    DEFAULT = nil

    def self.call(class_name)
      # TODO: how do we handle errors
      if class_name.present?
        callback = GetCallbackFrom.(class_name)
        return callback.send(:call)
      end
      DEFAULT
    end

  end
end
