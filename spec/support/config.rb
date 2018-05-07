StellarBase.configure do |c|
  c.modules = %i(bridge_callbacks)
  c.check_bridge_callbacks_authenticity = false
  c.horizon_url = "https://horizon-testnet.stellar.org"
  c.on_bridge_callback = "ProcessBridgeCallback"
end



