class ProcessFailedBridgeCallback
  def self.call(callback)
    Rails.logger.info "Woot failed a bridge callback #{callback.attributes}"
    false
  end
end
