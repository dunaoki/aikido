defmodule Aikido.Repo do
  use Ecto.Repo,
    otp_app: :aikido,
    adapter: Ecto.Adapters.Postgres
end
