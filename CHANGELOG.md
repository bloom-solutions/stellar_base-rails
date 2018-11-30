# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Changed
- Upgrade stellar-base to `>= 0.18.0`

### Added
- Optionally use [StellarSpectrum](https://github.com/bloom-solutions/stellar_spectrum-ruby) to send assets

## [0.10.0] - 2018-11-23
### Added
- Add `balances` module. Which mounts a `/balance/:asset_code` endpoint that returns the `max_amount` of a withdrawable asset

## [0.9.6] - 2018-11-07
### Fixed
- `DepositRequests::Trigger` skipping of sending assets when `SendAsset` fails

## [0.9.5] - 2018-10-19
### Fixed
- Missing local variable `address` when `StellarBase::AccountSubscriptions::GetOperations` rescues `Faraday::ClientError` exception
- Add error message in `/withdraw` if a failed policy occurred.

## [0.9.4] - 2018-10-08
### Fixed
- Skip remaining `SubscribeAccount` actions when `operations` cannot be found for an address

## [0.9.3] - 2018-10-08
### Fixed
- Do not blow up when fetching cursors of non-existent accounts
- Do not blow up when saving cursor of an empty operation set

## [0.9.2] - 2018-10-08
### Fixed
- SubscriptionWorker retry is `0` so death handlers are executed

## [0.9.1] - 2018-10-04
### Changed
- Pass in `GET /deposit` params in `how_from` class

## [0.9.0] - 2018-10-04
### Changed
- Remove dependency sidekiq-cron

### Fixed
- `#subscribe_to_accounts` config defaults to an empty array

## [0.8.1]
### Changed
- Change error lifting for `StellarBase.on_deposit_trigger`. Raising exception is too expensive

## [0.8.0]
### Added
- Add `StellarBase.on_account_event` and `.subscribe_to_accounts`

## [0.7.1]
### Added
- Add all attributes for a complete stellar_toml file

### Fixed
- Fix `LocalJumpError` issues for Rails apps that already have the `toml` mime type registered

## [0.7.0]
### Added
- Add `StellarBase.on_deposit_trigger`
- Add `StellarBase.configuration.stellar_network`

## [0.6.1]
### Changed
- Use 0 if `max_amount_from` in `DepositRequests::Operations::Create`

## [0.6.0]
### Added
- Add `depositable_assets` configuration
- Add `DepositRequest` model, operations, contracts and services
- Add `/deposit` API endpoint

## [0.5.6]
### Added
- Add `max_amount_from` configuration for `c.withdrawable_assets` to properly populate `WithdrawalRequest#max_amount`

## [0.5.5]
### Added
- Add errors in `/withdraw` to include errors for invalid asset codes instead of silently failing

## [0.5.4]
### Fixed
- Loosen version restriction of stellar-base gem

## [0.5.3]
### Changed
- Change `tomlrb` to `toml-rb`
- Fix bug in implicitly referred `TRANSFER_SERVER` route in `StellarToml`

## [0.5.2]
### Changed
- Added `tomlrb` in gemspec to fix errors in `/.well-known/stellar`

## [0.5.1] - 2018-08-31
### Fixed
- BridgeCallbacks operation should check if `bridge_callbacks` is included.

## [0.5.0]
### Added
- Add capability for mounting `/.well-known` using a route helper: `mount_stellar_base_well_known`

## [0.4.1]
### Added
- Show errors when unable to create withdraw request

## [0.4.0]
### Changed
- BridgeCallback model uses `operation_id` instead of `id`

### Added
- BridgeCallbacks (migration required) are saved in the database and uniqueness on the operation id is handled automatically.
- `on_bridge_callback` can be a proc or class itself (as long as it responds to call)
- Add factory bot definitions to `stellar_base/factories`

## [0.3.0]
### Added
- Added `c.check_bridge_callbacks_mac_payload` configuration option to flag if `/bridge_callbacks` will check for the `X_PAYLOAD_MAC` header that comes from the bridge server
- Added `c.bridge_callbacks_mac_key` configuration
- Added `StellarBase::BridgeCallbacks::VerifyMacPayload` service object to check if the callback is authentic

## [0.2.1]
### Added
- Added `BridgeCallbacks::Compare` step to check callback contents against operation/transaction details from Horizon

## [0.2.0]
### Added
- Added `c.check_bridge_callbacks_authenticity` configuration option to flag security controls
- Added `c.horizon_url` configuration
- Added `StellarBase::BridgeCallbacks::Check` service to check callback authenticity against horizon

## [0.1.2]
### Changed
- Moved `verify_authenticity_token` to `bridge_callbacks` controller

## [0.1.1]
### Added
- Update Rails dependency to `~> 5.1` from `~> 5.1.6`

## [0.1.0]
### Added
- Initial commit



