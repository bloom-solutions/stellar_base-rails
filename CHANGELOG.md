# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
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



