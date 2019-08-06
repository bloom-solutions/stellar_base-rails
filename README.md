# stellar_base-rails

When building Rails apps, we’d always implement /.well-known/stellar and other bits and pieces of the required endpoints in the Stellar Protocol. This gem solves receiving and responding to requests from some parts of the Stellar Protocol

## Usage

### Mounting
Adding modules to your routes:

```
mount StellarBase::Engine => "/stellar"

# Optionally, you can mount /.well-known/stellar
mount_stellar_base_well_known
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

To use the public network, ensure that you set the `Stellar` network to the [appropriate value](https://github.com/stellar/ruby-stellar-sdk#usage).

#### c.modules
You can supply what endpoints you want to activate with the gem

- Value(s): array of symbols. See the [modules documentation](docs/modules.md) for more details.
- Default: `%i(bridge_callbacks)`

#### c.distribution_account
This is the same distribution account that is setup in bridge. Currently, it is used in the `/withdraw` endpoint -- to tell the user to send the assets there.

- Value: Stellar account address

#### c.horizon_url
- Value(s): String, url to horizon
- Default: https://horizon.stellar.org
- This is where the engine will check bridge callbacks if `c.check_bridge_callbacks_authenticity` is turned on

#### c.stellar_network
- Values(s): "public" or "testnet"
- Default: testnet
- This tells stellar_base-rails what network it will use to send assets/lumens with. Currently used by the deposit module. If someone deposits a real asset, stellar_base sends the corresponding token to the requester.

#### c.stellar_toml
- Value(s): Hash, follow Stellar's [documentation](https://www.stellar.org/developers/guides/concepts/stellar-toml.html) for `stellar.toml`
- Example:
```
c.stellar_toml = { TRANSFER_SERVER: ... }
```
- When adding the URL of the transfer server, make sure not to add `/` at the end as described in the Stellar documentation:
```
# Correct:
https://example.com/stellar
https://example.com

# Bad:
https://example.com/stellar/
https://example.com/
```

#### c.sending_strategy

By default, this engine uses [ruby-stellar-sdk](https://github.com/stellar/ruby-stellar-sdk) to send assets. This does not have support for multi-process friendly distribution of assets.

One may opt to use [stellar_spectrum](https://github.com/bloom-solutions/stellar_spectrum-ruby) that allows sending of assets through multiple payment channels.

To configure this:

```ruby
config = {redis_url: "redis://redis", seeds: %w(S1 S2)}
c.sending_strategy = [:stellar_spectrum, config]
```

In the code above, `config` is the [configuration in StellarSpectrum](https://github.com/bloom-solutions/stellar_spectrum-ruby#usage), **except** the `horizon_url`. The value for `horizon_url` will be taken from `c.horizon_url`.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'stellar_base-rails'
```

And then execute:
```bash
$ bundle
```

If you're using `StellarBase.on_deposit_trigger` you'll need to install:

```
# Gemfile
gem("stellar-sdk", {
  github: "bloom-solutions/ruby-stellar-sdk",
  branch: "payment-memo",
})
```

## Development

```sh
rails db:migrate
rails db:migrate RAILS_ENV=test
```

Now you can run `rspec spec`

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
