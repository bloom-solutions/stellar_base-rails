# Modules

## Subscribing to Account Operations

Enable this if you want to receive operations on specific accounts. You will probably only either this or the bridge callback functionality, not both at the same time.

Enqueue the Sidekiq schedule with something like [sidekiq-cron](https://github.com/ondrejbartas/sidekiq-cron):

```
stellar_horizon_events:
  cron: "*/10 * * * * *"
  class: "StellarBase::EnqueueSubscribeAccountsJob"
```

And configure:

```ruby
StellarBase.configure do |c|
  c.modules = %i[account_operations]
  c.subscribe_to_accounts = %w(STELLAR_ADDR_1 STELLAR_ADDR_2)
  c.on_account_event = ->(address, tx, op) do
    puts "There is a #{op} for #{address} in the tx #{tx}"
  end

  # Note: you can also specify the class directly, as long as it responds to `.call`:
  c.on_account_event = MyProcessor
end
```

If you need to watch addresses created on the fly, make sure that you create the address (for example, when you bring on a new customer):

```ruby
StellarBase::AccountSubscription.create(address: "G-STELLAR_ADDRESS")
```
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

## [Deposit](https://github.com/stellar/stellar-protocol/blob/master/ecosystem/sep-0006.md#deposit)

Activate this by specifying `deposit` in the `modules` configuration.

This will mount the `/deposit` endpoint.

#### `StellarBase.on_deposit_trigger`

This engine gives you a method called `StellarBase.on_deposit_trigger` you call this in your application once you've received the asset in your system. This will send the appropriate token to the Stellar Account of the requester.

- Parameters:
  - network, deposit_address, tx_id, amount
    - `network` - this would be matched on the networks available on the `depositable_assets`
    - `deposit_address` - where it was deposited
    - `tx_id` - the Transaction ID in that network
    - `amount` - amount of that asset received. It will send the same amount of the corresponding Stellar Asset to the requester.

#### c.depositable_assets
- Value(s):
  - path to a YAML configuration file describing what can be deposited (see below), or
  - JSON: array of JSON objects following the YAML but in JSON format, or
  - Ruby array of hashes
  - Sample [deposit.yml](docs/deposit.yml)
- Required
- Notes:
  - `max_amount_from` is a class that you define that will run whenever a deposit for that asset is requested. Typically this should tell the API user the maximum amount of the specific asset you have that you can send to a users wallet. It'll populate the `max_amount` response field. If you don't define anything, it won't run that class and will return `nil` for the `max_amount`
    - The `max_amount_from` class is expected a `BigDecimal` return.
    - The `max_amount_from` class is expected to implement a `self.call` method. It won't be passed any parameters
  - `how_from` is a class that you define that will run whenever a deposit for that asset is requested. It'll populate the `how` response field. If you don't define anything, it won't run that class and will return `nil` for the `how`
    - The `how_from` class is expected a `String` return.
    - The `how_from` class is expected to implement a `self.call` method. It won't be passed any parameters
