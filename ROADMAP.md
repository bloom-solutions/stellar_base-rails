# Roadmap

### 0.2.x

#### Securing /bridge_callbacks

Implement application-level security measurements on securing the bridge_callbacks endpoint. Aside from the recommendation of Stellar to accept payloads coming from the Bridge Server IP, we can also do the following on this rails engine.

1. Implementing checking payloads with the mac_key headers
2. Implementing checking payloads with the api_key headers
3. Another layer of defense, check authenticity of the callback by checking it against Horizon:
  a. Existence of operation and transaction ID's against a Horizon instance
  b. From, Amount, Issuer and other transaction details

Number 3 can be implemented as follows:

```
  c.bridge_callbacks_authenticity = false
  c.horizon_url = "https://horizon_url.com"
```

If `c.check_bridge_callbacks_authenticity` is set to `true`, it'll check incoming callbacks against a Horizon instance

****

### 0.3.0
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


### 0.4.0

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
