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
    - `StellarOperation`
      - call `#stellar_transaction` on this to get the Stellar Transaction
- Required
- Notes:
  - This is run when a payment is detected. You need to make sure that AccountSubscriptions is enabled by adding it to the schedule.
  - You should put code that will ensure that you don't double-send in case the callback is called multiple times.
  - See the models `StellarTransaction` & `StellarPayment` for the attributes that can be accessed. Currently, only payment operations are reported. We will add more as needed.

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
  - `extra_info_from` is a class that you define that will run whenever a deposit for that asset is requested. It will populate `extra_info` of the `deposit_request` record with the hash returned by the configured callback. For example, if `{deposit_etas: [1, 1], [2, 2]}` is returned, then the JSON version of that is saved in the database. Useful if you want to customize/attach any extra info to the DepositRequest.
    - The `extra_info_from` class is expected a `Hash` return.
    - The `extra_info_from` class is expected to implement a `self.call` method. You can implement the `self.call` to accept asset details (matching `StellarBase.configuration.depositable_assets`).
    - Example: see `GetDepositExtraInfo` in the dummy app

## Balances

Activate this by specifying `balances` in the `modules` configuration.

This will mount the `/balance` endpoint. It returns the `max_amount` of a `withdrawable_asset`. This should be used in conjunction with `withdraw` module.

## [Getting Fees](https://github.com/stellar/stellar-protocol/blob/master/ecosystem/sep-0006.md#fee)

Add a `fees` entry in the array of `config.modules`. This will mount a `GET /fee` API endpoint described in [here](https://github.com/stellar/stellar-protocol/blob/master/ecosystem/sep-0006.md#fee).

You'll need to configure a `fee_fixed_quote_from` value in your `depositable_assets` or `withdrawable_assets` per asset. `fee_fixed_quote_from` contains a class that you define which will run whenever a `GET /fee` request comes for that specific asset:

```
ex:

config.withdrawable_assets = [
  {
    type: "crypto",
    network: "bitcoin",
    asset_code: "BTCT",
    issuer: ENV["ISSUER_ADDRESS"],
    max_amount_from: GetMaxAmount.to_s,

    # Fees
    ## You can set it directly
    fee_fixed: 0.01,
    fee_percent: 1,
    ## Or you can get it programatically (fixed fees only as of now):
    fee_fixed_quote_from: GetWithdrawFeeFixedQuoteFrom, # used in `/fee`
    fee_fixed_from: GetWithdrawFeeFixedFrom, # used to set the `fee_fixed` in `/withdraw`
  }
]

# or

config.depositable_assets = [
  {
    type: "crypto",
    network: "bitcoin",
    asset_code: "BTCT",
    issuer: ENV["ISSUER_ADDRESS"],
    distributor: ENV["DISTRIBUTOR_ADDRESS"],
    distributor_seed: ENV["DISTRIBUTOR_SEED"],
    how_from: GetHow.to_s,
    max_amount_from: GetMaxAmount.to_s,
  },
]

class GetWithdrawFeeFixedQuoteFrom

  def self.call(fee_request)
    # insert code that returns a BigDecimal
    # by getting from the BTC network or something
  end

end
```

#### Notes

- the class that you put in `fee_fixed_quote_from` would be passed a `FeeRequest` model, `FeeRequest` is an object that has the following attributes: `asset_code, operation, type, amount`.
- the class should implement a `def self.call` method that accepts the `FeeRequest` model
- the service class should return a `BigDecimal` value, that value would be returned to the requester.
- If you don't supply a `fee_fixed_quote_from` class, whenever someone goes to `GET /fee` and asks for the fees for that `asset_code`, `GET /fees` will return 0 for that `asset_code`.
- In the example above, when someone asks `GET /fee?operation=deposit&asset_code=BTCT` it will return with 0.
