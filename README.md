# sandbox

Implementation of a API test server that returns JSON encoded accounts and transactions.

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

- look into Account or Transaction

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

## Todo:

Maybe some more stuff like:

1.  Token - for more secure enviroments in ENV vars:
```
      export SANDBOX_API_TOKEN='["first_token", "second_token"]'
```
2. more dynamic generation of Transactions
3. LiveView dashboard - maybe metrics or admin interface for Token handling
