# Sandbox

Implementation of an API test server that returns JSON encoded accounts and transactions - no database, dynamic generation of data, almost stateless.

## routes
```
GET /accounts
GET /accounts/:account_id
GET /accounts/:account_id/transactions
```
## basic_auth -> Api Token in user field

- simple basic auth in [Router](https://github.com/razuf/sandbox/blob/master/lib/sandbox_web/router.ex)

- Api Token opaque

- can be generated

- state inside: start balance and offset for generating dynamic data - see [Token](https://github.com/razuf/sandbox/blob/master/lib/sandbox/data/token.ex)


## generate example data

- look into [Account](https://github.com/razuf/sandbox/blob/master/lib/sandbox/data/account.ex) or [Transaction](https://github.com/razuf/sandbox/blob/master/lib/sandbox/data/transaction.ex)

## API Token generation

   
      mix help sandbox.gen.token

  Generate a new Api Token:

      mix sandbox.gen.token start_balance:float offset:integer

Example:

      mix sandbox.gen.token 999999.12 8

  The first argument is any start balance with 2 decimal places (more decimal places are cut off).
  The second argument is an offset integer to generate dynamic values from the given lists.

  To use this generated api token please put it into config.exs:

      config :sandbox, sandbox_api_token: ["first_token", "second_token"]

alternatively and more secure is ENV var handling (separation with ":"):
```
  export SANDBOX_API_TOKEN=first_token:second_token
```

## Token generation via http request

Because it's for dev testing - any tester could create automatically their own token.

added route:
```
GET /token
```

response:
```
{
    "token": "test_api_GBXKTT42_H3WBFSSY"
}
```


## Todo:

Maybe some more stuff like:

1. Balance amount check - because transaction could run out of money if the balance was to low (maybe allow negative balance???)

