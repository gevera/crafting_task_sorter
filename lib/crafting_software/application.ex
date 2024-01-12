defmodule CraftingSoftware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Plug.Cowboy.child_spec(
      #   scheme: :http,
      #   plug: CraftingSoftware.HttpEndpoint,
      #   options: [port: 4000]
      # )
      {Plug.Cowboy,
       scheme: :http, plug: CraftingSoftware.Infrastructure.HttpEndpoint, options: [port: 4000]}
      # Starts a worker by calling: CraftingSoftware.Worker.start_link(arg)
      # {CraftingSoftware.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CraftingSoftware.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
