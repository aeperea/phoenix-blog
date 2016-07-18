use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :pxblog, Pxblog.Endpoint,
  secret_key_base: "ffQZDHBwd2I2EH3BVkhG/Oe50q1I1ScdIyM3Mekcoh0z6AMf8BBVlJxEaM/rBAep"

# Configure your database
config :pxblog, Pxblog.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "pxblog_prod",
  pool_size: 20
