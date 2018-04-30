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
  c.bridge_on_receive = "StellarBridgeReceive::SaveTxn"
end
```

#### c.modules
- You can supply what endpoints you want to activate with the gem
- `bridge_callbacks` - this will mount a HTTP/S POST endpoint that acts as callback receiver for bridge server payments on the path. It will call your `.bridge_on_receive` class.

#### c.bridge_receive
- Once the bridge_receive endpoint receives a callback, the class will be called with .call
- The class will be passed with the bridge server callback payload contained in a `StellarBase::BridgeCallback` object.
- The class will be expected to return a boolean, return true if the callback was processed properly

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
