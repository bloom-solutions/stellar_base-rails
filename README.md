# stellar_base-rails

When building Rails apps, we’d always implement /.well-known/stellar and other bits and pieces of the required endpoints in the Stellar Protocol. This gem solves receiving and responding to requests from some parts of the Stellar Protocol

## Usage

### Mounting
Adding modules to your routes:

```
mount StellarBase::Engine => "/stellar_base"
```

```sh
rails stellar_base:install:migrations
rails db:migrate
```

### Configuration
Create an initializer in your rails application:

```
# config/initializers/stellar_base-rails.rb

StellarBase.configure do |c|
  c.modules = %i(bridge_callbacks)
  c.horizon_url = "https://horizon.stellar.org"

  c.on_bridge_callback = "StellarBridgeReceive::SaveTxn"
  c.check_bridge_callbacks_authenticity = true
  c.check_bridge_callbacks_mac_payload = false
  c.bridge_callbacks_mac_key = "test"
end
```


#### c.modules
You can supply what endpoints you want to activate with the gem

- Value(s): array of symbols. See the [modules documentation](docs/modules.md) for more details.
- Default: `%i(bridge_callbacks)`

#### c.horizon_url
- Value(s): String, url to horizon
- Default: https://horizon.stellar.org
- This is where the engine will check bridge callbacks if `c.check_bridge_callbacks_authenticity` is turned on

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
