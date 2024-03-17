# land-invest-api

An Api for a Land Banking App

<!-- start container -->

```bash
# start container
docker compose -f local.yml restart && docker compose -f local.yml start
# run test
docker compose -f local.yml exec app python manage.py test -v 2
```

# Models

- User

  - first_name
  - last_name
  - email
  - username
  - phone_number
  - location
  <!-- - is_investor
  - is_agency
  - is_agent -->

<!-- - Agency

  - user
  - title
  - has_agent

- Agency Agent

  - user
  - agency
  - role [agent_by_default] -->

- Deal | Property [track price change]

  - title
  - description
  - owner
    <!-- - agency -->
    <!-- - agent -->
  - outright
  - location
  - no_of_unit
  - price_per_unit
  - percentage_returns
  - no_of_investors
  - gallery: Deal Image[]

- Deal Image

  - deal
  - image

- Pocket

  - title (for savings only)
  - balance
  - user
  - pocket_type (wallet|savings)

- Transaction

  - pocket
  - amount
  - balance_on_transaction
  - transaction_type
  - status [pending,success,failed]

- Investment
  - deal
  - investor
  - transaction
  - amount
  - deal_amount_on_purchase
  - units
  - is_matured

# endpoints

- SignUp # done
- Login # done
- Forgot Password # done
- Update Profile # done
- all investment deals # done
- featured investment deals # done
- deal details # done
- forget password with email # done
- Verify Reset Token # done

- quick save
  1. destination (pocket)
  2. amount
- withdraw
  1. source
  2. amount
- last_withdrawal
- last_savings
- total_investments

  1. amount
  2. % returns (sum of profits)

- previous transactions
  - transaction_type
  - price
  - title (if from pocket [use pocket title {withdrawal or deposit}] else [])
  - balance_on_transaction
  - amount
  - date_created

### forgot password

- email
- token
- to reset

### Changes

- daily savings target to balance left to target
- Every endpoint should actually be versioned, some like api/v1/deals/.... Please do this in a different PR

##### TODO

- create wallet after signup #done
- get user wallet #done
- create savings #done

- top-up savings
- withdraw from savings
- send

- separate wallet and savings
-

## proposal for transaction

- transaction_id
- wallet
- savings
- amount
- balance_on_transaction
- transaction_type # TRANSFER | CREDIT | DEBIT
- transaction_logistics # WTS | STW | THIRDPARTY
- source # WALLET | SAVINGS | FLUTTERWAVE
- status
<!-- - source -->

```
transaction_id
source
destination
balance on transaction

money should come in from outside the business into one point (funding)
```

# SavingsTransaction

- savings
- transaction_id
- transaction_type # credit | debit
- status # success|pending|failed
- balance_on_transaction
- amount_transacted
- from -> SAVINGS | WALLET
- to -> SAVINGS | WALLET

```js
A => s -> w
B => w -> s
C => ex -> w
```

<!-- - wallet -->
<!-- -  -->
<!-- - from_savings -->
<!-- - to_wallet -->

<!--
- from_wallet
- to_savings
-->

# WalletTransaction

- wallet
- transaction_id
- transaction_type # credit | debit
- status # success|pending|failed
- balance_on_transaction
- amount_transacted
- from -> SAVINGS | WALLET | EXTERNAL
- to -> SAVINGS | WALLET | EXTERNAL

<!-- - savings -->

```js
A => s -> w
B => w -> s
C => ex -> w
```

- fetch wallet deposit balance

# wallet

- top up wallet #done
- fetch wallet transactions
- move money from wallet to savings

# savings

- fetch savings transactions
- move money from savings to savings
- move money from savings to wallet

# login

- send email verification token on unverified login attempt

# urgent

- creating savings
- adding transaction ref for internal and external transactions should exist
- check how flutterwave webhooks work
- login_with_pin #done
- set_login_pin #done
- set_transaction_pin #done

<!-- handling transactions from flutterwave -->

- webhook
  - check if transaction_id with user email exists
    - if it exists: update the status and details
    - else: create one using email and transaction_id and create webhook
- topup
  - check if transaction_id with user email exists
    - if: check if webhook with that transaction_id exists
      - if it exists: create one using email and transaction_id from webhook
      - else: create one using email and transaction_id
    - else: update the status and details

<!-- handling transactions from flutterwave -->

# all endpoints

- Savings
  - ~~fetch user's savings~~
  - ~~add savings~~
  - ~~view goal details~~
  - ~~savings withdrawal to wallet~~
  - savings withdrawal to bank
  - savings topup from bank
  - ~~fetch savings transactions~~
- Wallet
  - ~~fetch wallet transactions~~
  - ~~fetch user wallet~~
  - ~~wallet topup~~
- Property
  - fetch properties
  - fetch single property
  - payment for properties
  - fetching user's properties
    - sold
    - unsold
  - sell user's properties
- Notification
  - fetching notifications
- User Profile
  - ~~fetch user's details~~
  - ~~updating user's profile~~
  - ~~change password~~
  - ~~reset password~~
- Referrals
  - creating referral link
  - fetching user's referrals
- Misc [wallets,savings,transactions]
  - filtering
  - pagination

# notes

- ~~return 401 or 403 for wrong info during otp verification~~
- ~~send otp should return 20X when account has already been verified~~
- ~~correct tests~~
- ~~internal transactions~~
  - ~~savings-wallet~~
  - ~~wallet-savings~~
- change payment integration
