defmodule Aikido.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AikidoWeb.Telemetry,
      Aikido.Repo,
      {DNSCluster, query: Application.get_env(:aikido, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Aikido.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Aikido.Finch},
      # Start a worker by calling: Aikido.Worker.start_link(arg)
      # {Aikido.Worker, arg},
      # Start to serve requests, typically the last entry
      AikidoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Aikido.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AikidoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
