defmodule P7.Mixfile do
  use Mix.Project

  def project do
    [app: :p7,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger],
     mod: {P7, []}]
  end

  defp deps do
    [
      {:poolboy,  github: "devinus/poolboy" },
      {:exactor,  "~> 2.2"},
      {:blocking_queue, "~> 1.0"},
    ]
  end
end
