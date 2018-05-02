StellarBase.configure do |c|
  c.modules = %i(bridge_callbacks)
  c.on_bridge_callback = "ProcessBridgeCallback"
end



