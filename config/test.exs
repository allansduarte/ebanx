import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ebanx, Ebanx.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ebanx_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ebanx_web, EbanxWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+4pKXESlbxrQyacSeDFwxQte+9oAeDoobToKn00SuT1HB0rjPYVNG5PVING7myKo",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :ebanx, Ebanx.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
