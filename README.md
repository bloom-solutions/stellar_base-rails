# stellar_base-rails

When building Rails apps, we’d always implement /.well-known/stellar and other bits and pieces of the required endpoints in the Stellar Protocol. This gem solves receiving and responding to requests from some parts of the Stellar Protocol

## Usage

### Mounting
Adding modules to your routes:

```
stellar_base_for :well_known
stellar_base_for :federation, path: "/stellar-federation"
stellar_base_for :bridge_callbacks, path: "/stellar/bridge-receiver"
```

- `well_known` - this will mount a `/.well-known/stellar` endpoint that serves your Stellar TOML. Declaring a custom path here would be ignored, since Stellar expects your Stellar TOML in a specific path. You can configure the contents of StellarTOML by configuring a hash.
- `federation` - this will mount the federation endpoint on a path. It will call your `.federation_on_query` class.
- `bridge_callbacks` - this will mount a HTTPS endpoint that acts as callback receiver for bridge server payments on the path. It will call your `.bridge_on_receive` class.

### Configuration
Create an initializer in your rails application:

```
# config/initializers/stellar_base-rails.rb
StellarBase.configure do |c|
  c.stellar_toml = {
    FEDERATION_SERVER: stellar_federation_url,
    AUTH_SERVER: 'https://authserver.com',
    ACCOUNTS: [
      "$sdf_watcher1",
      "GAENZLGHJGJRCMX5VCHOLHQXU3EMCU5XWDNU4BGGJFNLI2EL354IVBK7",
    ],
    CURRENCIES: [
      code: "BTC",
      issuer: "GCZJM35NKGVK47BB4SPBDV25477PZYIYPVVG453LPYFNXLS3FGHDXOCM",
      display_decimals: 2,
    ],
  }
  c.federation_on_query = "StellarFederation::FindRecord"
  c.bridge_on_receive = "StellarBridgeReceive::SaveTxn"
end
```

#### c.federation_on_query
- Once the federation endpoint receives a query, it’s up to you to write a class that the engine will run.
- The class will be called with .call and it can be configured on `.federation_on_query`.
- The class will be passed with the params contained in a `StellarBase::FederationQuery` object.
- The `StellarBase::FederationQuery` object will contain the parameters in the federation query.
- The class will be expected to return a `StellarBase::FederationQueryResponse`, or you could return nil if no record is found.

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
