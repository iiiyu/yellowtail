defmodule Toolkit.MixProject do
  use Mix.Project

  def project do
    [
      app: :toolkit,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:ethereumex, :ex_abi, :hexate],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ethereumex, "~> 0.10"},
      {:ex_abi, "~> 0.5"},
      {:hexate, ">= 0.6.0"}
    ]
  end
end
