defmodule Snappyrex.MixProject do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/c2bw/snappyrex"

  def project do
    [
      app: :snappyrex,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "Snappy (Rust) NIF for Elixir",
      test_coverage: [ignore_modules: [Snappy.Nif]]
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
      {:rustler, "~> 0.36.1", runtime: false}
    ]
  end

  defp package do
    [
      name: "snappyrex",
      files: [
        "lib",
        "native",
        "cargo.toml",
        "cargo.lock",
        "mix.exs",
        "mix.lock",
        "README.md",
        "LICENSE.md"
      ],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @url,
        "Documentation" => "https://hexdocs.pm/snappyrex"
      }
    ]
  end
end
