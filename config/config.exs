# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :flash,
  ecto_repos: [Flash.Repo]

# Configures the endpoint
config :flash, Flash.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("PHOENIX_SECRET_KEY_BASE"),
  render_errors: [view: Flash.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Flash.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configure your database
config :flash, Flash.Repo,
  adapter: Ecto.Adapters.Postgres,
  # For Heroku
  url: System.get_env("DATABASE_URL"),
  # For other environments
  username: System.get_env("PG_USER"),
  password: System.get_env("PG_PASS"),
  database: System.get_env("PG_DB"),
  hostname: System.get_env("PG_HOST"),
  pool_size: 10

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Auth
config :ueberauth, Ueberauth,
  providers: [ twitter: { Ueberauth.Strategy.Twitter, [] } ]

# Make sure to set your Twitter callback URL on your OAuth app!
# For development, it should be http://localhost:4000/auth/twitter/callback
config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")


config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Flash",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  # replace this before production, obviously 💻
  secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
  serializer: Flash.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"