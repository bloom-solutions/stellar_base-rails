# Roadmap

### 0.2.0
- Federation Endpoint
```
  c.modules = (federation)
  c.federation_on_query = "StellarFederation::FindRecord"
```

**c.federation_on_query**
- Once the federation endpoint receives a query, it’s up to you to write a class that the engine will run.
- The class will be called with .call and it can be configured on `.federation_on_query`.
- The class will be passed with the params contained in a `StellarBase::FederationQuery` object.
- The `StellarBase::FederationQuery` object will contain the parameters in the federation query.
- The class will be expected to return a `StellarBase::FederationQueryResponse`, or you could return nil if no record is found.


### 0.3.0

- Optionally mount a well-known

```
  c.modules = (well_known)
  c.stellar_toml = {
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
```

Mounting something outside the engine namespace is possible via:

```
# config/routes.rb

if StellarBase.included_module?(:well_known)
  Rails.application.routes.draw do
    get(
      "/.well-known/stellar" => "stellar_base/stellar#well_known",
      as: :stellar_base_stellar_well_known,
      defaults: { format: "toml" },
    )
  end
end
```
