# Modules

## Bridge Callbacks

Activate this by specifying `bridge_callbacks` in the `modules` configuration.

This will mount the `/bridge_callbacks` endpoint. Make sure you setup `on_bridge_callback` like below.

#### c.on_bridge_callback
- Value(s):
  - object that responds to `.call` accepts the argument:
    - `bridge_callback`
  - String version of the object
- Default: None
- Once the bridge_receive endpoint receives a callback, the class will be called with .call
- The class will be passed with the bridge server callback payload contained in a `StellarBase::BridgeCallback` object.
- The class will be expected to return a boolean, return true if the callback was processed properly
- Warning: The bridge server will may post multiple callbacks with the same ID, make sure you handle these correctly. https://github.com/stellar/bridge-server/blob/master/readme_bridge.md#callbacksreceive

```ruby
StellarBase.configure do |c|
  c.modules = %i[bridge_callbacks]
  c.on_bridge_callback = "ProcessBridgeCallback"
end
```

and you have the class defined:

```ruby
class ProcessBridgeCallback
  def self.call(bridge_callback)
  end
end
```

#### c.check_bridge_callbacks_authenticity
- Value(s): `true` or `false`
- Default: `false`
- This secures the `/bridge_callbacks` endpoint from fake transactions by checking the transaction ID and it's contents against the Stellar Blockchain. If it doesn't add up, `/bridge_callbacks` endpoint will respond with a 422

#### c.check_bridge_callbacks_mac_payload
- Value(s): `true` or `false`
- Default: `false`
- This secures the `/bridge_callbacks` endpoint from fake transactions by checking the `X_PAYLOAD_MAC` header for 1.) existence and 2.) if it matches the HMAC-SH256 encoded raw request body

####  c.bridge_callbacks_mac_key
- Value(s): Any Stellar Private Key, it should be the same as the mac_key configured in your bridge server
- Default: None
- This is used to verify the contents of `X_PAYLOAD_MAC` by encoding the raw request body with the decoded `bridge_callback_mac_key` as the key

## [Withdraw](https://github.com/stellar/stellar-protocol/blob/master/ecosystem/sep-0006.md#withdraw)

Activate this by specifying `withdraw` in the `modules` configuration.

This will mount the `/withdraw` endpoint.

To detect incoming payments of Stellar assets, you need to have bridge setup for this to work. The quickest way would be to use the `bridge_callbacks` module:

```ruby
StellarBase.configure do |c|
  c.modules = %i[bridge_callbacks withdraw]
  c.on_bridge_callback = "ProcessBridgeCallback"
end

class ProcessBridgeCallback
  def self.call(bridge_callback)
    # You can do other things
    StellarBase::WithdrawalRequests::Process.(bridge_callback)
  end
end
```

You can also just pass in `StellarBase::WithdrawalRequests::Process` directly into `on_bridge_callback` if you don't need to do anything else.

#### c.withdrawable_assets
- Value(s):
  - path to a YAML configuration file describing what can be withdrawn (see below), or
  - JSON: array of JSON objects following the YAML but in JSON format, or
  - Ruby array of hashes
  - Sample [withdrawal.yml](docs/withdraw.yml)
- Required
- Notes: `max_amount_from` is a class that you define that will run whenever a withdrawal for that asset is requested. It'll populate the `max_amount` response field. If you don't define anything, it won't run that class and will return `nil`
  - The `max_amount_from` class is expected a `BigDecimal` return.
  - The `max_amount_from` class is expected to implement a `self.call` method. It won't be passed any parameters

#### c.on_withdraw
- Value(s):
  - object that responds to `.call` accepts the arguments:
    - `withdrawal_request`
    - `bridge_callback`
  - String version of the object
- Required
- Notes: This is run when a `GET /withdraw` is received and has passed validations

Example:

```ruby
StellarBase.configure do |c|
  # ....
  c.on_withdraw = ProcessWithdrawal
  c.on_withdraw = "ProcessWithdrawal" # constantize will be called on this when a request is received

  c.on_withdraw = ->(withdrawal_request, bridge_callback) do
    # contact hot wallet here
  end
end

class ProcessWithdrawal
  def self.call(withdrawal_request, bridge_callback)
    # Contact hot wallet here
  end
end
```
