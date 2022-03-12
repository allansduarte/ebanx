defmodule Ebanx.Repo do
  use Ecto.Repo,
    otp_app: :ebanx,
    adapter: Ecto.Adapters.Postgres
end
