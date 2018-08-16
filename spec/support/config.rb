RSpec.configure do |c|

  c.before(:each) do
    StellarBase.configure do |c|
      c.modules = %i(bridge_callbacks)
      c.horizon_url = "https://horizon-testnet.stellar.org"

      c.on_bridge_callback = "ProcessBridgeCallback"
      c.check_bridge_callbacks_authenticity = false
      c.check_bridge_callbacks_mac_payload = false
      c.bridge_callbacks_mac_key = "sample"
    end
  end

end
