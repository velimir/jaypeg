defmodule Jaypeg.MixProject do
  use Mix.Project

  def project do
    [
      app: :jaypeg,
      version: "0.1.0",
      compilers: [:elixir_make] ++ Mix.compilers,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_make, "~> 0.5.2", runtime: false},
      {:ex_doc, "~> 0.20.2", runtime: false}
    ]
  end
end
