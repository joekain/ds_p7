defmodule P7 do
  use Application

  def pool_name, do: :p7_pool

  defp poolboy_config do
    [
      {:name, {:local, pool_name}},
      {:worker_module, P7.Worker},
      {:size, 5},
      {:max_overflow, 10}
    ]
  end

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config(), [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: P7.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
