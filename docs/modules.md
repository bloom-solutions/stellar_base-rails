# Modules

## Subscribing to Account Operations

Enable this if you want to receive operations on specific accounts. You will probably only use either this or the bridge callback functionality, not both at the same time.

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
  c.horizon_url = "http://myhorizon.com"
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

### Sidekiq Unique Jobs

This gem uses [SidekiqUniqueJobs](https://github.com/mhenrixon/sidekiq-unique-jobs) to ensure that only one job is enqueued at a time that fetches information about the accounts. If your Sidekiq process dies prematurely, it is possible that locks will not be removed. When this occurs and the Sidekiq process boots up, none of the locked jobs will be enqueued. Consider putting something like this in your apps:

```ruby
if Sidekiq.server?
  SidekiqUniqueJobs::Digests.all.each do |d|
    SidekiqUniqueJobs::Digests.del(digest: d)
  end
end
```

This will delete all digests every time your Sidekiq process is started. If you have more than one Sidekiq process and the one of them enqueues jobs before the other, then a lock may be deleted for a job that is currently running. This should be a safe method if you only have one Sidekiq process running.

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
  - object that responds to `.call` which accepts, as arguments, instances of the following:
    - `WithdrawalRequest`
    - `StellarTransaction`
    - `StellarOperation`
- Required
- Notes:
  - This is run when a payment is detected. You need to make sure that AccountSubscriptions is enabled by adding it to the schedule.
  - You should put code that will ensure that you don't double-send in case the callback is called multiple times.

Example:

```ruby
StellarBase.configure do |c|
  # ....
  c.on_withdraw = ProcessWithdrawal
  c.on_withdraw = "ProcessWithdrawal" # constantize will be called on this when a request is received

  c.on_withdraw = ->(withdrawal_request, stellar_tx, stellar_op) do
    # contact hot wallet here
  end
end

class ProcessWithdrawal
  def self.call(withdrawal_request, stellar_tx, stellar_op)
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
- Returns an object that:
  - has the method to `#success?` (and `#failure?` which is the opposite Boolean value). When it is not successful, the reason may be taken from `#message`.
  - contains the `Deposit` (accessed via `#deposit`). This is useful to fetch when you want to know the Stellar transaction id (`Deposit#stellar_tx_id`) and the memo, via `Deposit#deposit_request`'s `#memo`.

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
    - The `how_from` class is expected to implement a `self.call` method. You can implement the `self.call` to accept parameters and it'll be passed the request parameters from `GET /deposit`, the parameters will be in a form of a `Hash`

## Balances

Activate this by specifying `balances` in the `modules` configuration.

This will mount the `/balance` endpoint. It returns the `max_amount` of a `withdrawable_asset`. This should be used in conjunction with `withdraw` module.
