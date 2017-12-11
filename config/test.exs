use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tartu_parking, TartuParking.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :tartu_parking, TartuParking.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "tartu_parking_test",
  hostname: "localhost",
  port:    "5433",
  pool: Ecto.Adapters.SQL.Sandbox,
  extensions: [{Geo.PostGIS.Extension, library: Geo}],
  types: TartuParking.PostgresTypes

config :hound, driver: "chrome_driver"
config :tartu_parking, sql_sandbox: true

config :tartu_parking, :http_client, HTTPoison