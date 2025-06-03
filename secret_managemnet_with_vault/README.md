#

## Install vault

https://developer.hashicorp.com/vault/install

## Vault modes

- Dev
  - in memory
- and Prod

## Get started

```Bash
vault server -dev
```

But for changing the token name to root

` -dev-root-token-id=<string>` gotten from

```Bash
vault server -dev -h
```

to login

```Bash
vault login
```

to create a secret

```Bash
vault kv put
```

and to get secret

```Bash
vault kv get
```

## Resources

