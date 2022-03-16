defmodule Appb.Repo do
  use Ecto.Repo,
    otp_app: :appb,
    adapter: Ecto.Adapters.Postgres
end
