# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :tartu_parking,
  ecto_repos: [TartuParking.Repo], extensions: [{Geo.PostGIS.Extension, library: Geo}]

# Configures the endpoint
config :tartu_parking, TartuParking.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aK9mUTKBQKlL+fEPjjm09Dwll86i1YepXrMD4QHVduGz6J6/fXAitZb247/W5yMW",
  render_errors: [view: TartuParking.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TartuParking.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :canary, unauthorized_handler: {TartuParking.SessionController, :unauthorized}

config :guardian, Guardian,
  issuer: "TartuParking",
  ttl: {30, :days},
  allowed_drift: 2000,
  secret_key: "Ha3WY/a7iDzjd2GfzUr57BJrnRjILZ91TGGI/31Dq++lNErNa4oe04XeSr8FobBw",
  serializer: TartuParking.GuardianSerializer
