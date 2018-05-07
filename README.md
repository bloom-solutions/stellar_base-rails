# stellar_base-rails

When building Rails apps, we’d always implement /.well-known/stellar and other bits and pieces of the required endpoints in the Stellar Protocol. This gem solves receiving and responding to requests from some parts of the Stellar Protocol

## Usage

### Mounting
Adding modules to your routes:

```
mount StellarBase::Engine => "/stellar_base"
```

### Configuration
Create an initializer in your rails application:

```
# config/initializers/stellar_base-rails.rb

StellarBase.configure do |c|
  c.modules = %i(bridge_callbacks)
  c.horizon_url = "https://horizon.stellar.org"

  c.check_bridge_callbacks_authenticity = true
  c.on_bridge_callback = "StellarBridgeReceive::SaveTxn"
end
```


#### c.modules
- Value(s): array of symbols
  - bridge_callbacks - when supplied this will mount the `/bridge_callbacks` endpoint
- Default: `%i(bridge_callbacks)`
- You can supply what endpoints you want to activate with the gem
- `bridge_callbacks` - this will mount a HTTP/S POST endpoint that acts as callback receiver for bridge server payments on the path. It will call your `.on_bridge_callback` class.

#### c.on_bridge_callback
- Value(s): Class
- Default: None
- Once the bridge_receive endpoint receives a callback, the class will be called with .call
- The class will be passed with the bridge server callback payload contained in a `StellarBase::BridgeCallback` object.
- The class will be expected to return a boolean, return true if the callback was processed properly
- Warning: The bridge server will may post multiple callbacks with the same ID, make sure you handle these correctly. https://github.com/stellar/bridge-server/blob/master/readme_bridge.md#callbacksreceive


#### c.check_bridge_callbacks_authenticity
- Value(s): `true` or `false`
- Default: `false`
- This secures the `/bridge_callbacks` endpoint from fake transactions by checking the transaction ID and it's contents against the Stellar Blockchain. If it doesn't add up, `/bridge_callbacks` endpoint will respond with a 422

#### c.horizon_url
- Value(s): String, url to horizon
- Default: https://horizon.stellar.org
- This is where the engine will check bridge callbacks if `c.cross_reference_bridge_callback` is turned on

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'stellar_base-rails'
```

And then execute:
```bash
$ bundle
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
