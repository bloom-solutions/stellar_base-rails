# Roadmap

## /federation/queries

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

## rails g stellar_base:install

- Convenience generator to automatically mount the engine to routes and to create an initializer template
