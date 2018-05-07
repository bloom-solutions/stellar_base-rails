# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

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



