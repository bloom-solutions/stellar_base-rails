class ProcessBridgeCallback
  def self.call(callback)
    Rails.logger.info "Woot got a bridge callback #{callback.to_hash}"
    true
  end
end
