use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :flash, FlashWeb.Endpoint,
  secret_key_base: "kfGO4EsJf3ORBsMTMoVhee+MUcOshs46IpSfTxOSHTYxFgx1LOjlckm6t4EJbu1Z"

# Configure your database
config :flash, Flash.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "flash_prod",
  pool_size: 15
