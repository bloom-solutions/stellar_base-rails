class ProcessBridgeCallback
  def self.call(callback)
    Rails.logger.info "Woot got a bridge callback #{callback.attributes}"
    true
  end
end
