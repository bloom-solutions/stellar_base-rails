class ProcessFailedBridgeCallback
  def self.call(callback)
    Rails.logger.info "Woot failed a bridge callback #{callback.to_hash}"
    false
  end
end
