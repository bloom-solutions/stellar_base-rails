module StellarBase
  class ConfiguredClassRunner

    DEFAULT = nil

    def self.call(class_name)
      # TODO: how do we handle errors
      return class_name.constantize.send(:call) if class_name.present?
      DEFAULT
    end

  end
end
