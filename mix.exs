defmodule Snappyrex.MixProject do
  use Mix.Project

  @version "0.1.1"
  @url "https://github.com/c2bw/snappyrex"

  def project do
    [
      app: :snappyrex,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      description: "Snappy compression/decompression for Elixir as a Rust NIF",
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
      {:ex_doc, "~> 0.37.3", only: :dev, runtime: false},
      {:rustler, "~> 0.36.1", runtime: false}
    ]
  end

  defp package do
    [
      name: "snappyrex",
      source_url: @url,
      files: [
        "lib",
        "native",
        "cargo.toml",
        "cargo.lock",
        "mix.exs",
        "mix.lock",
        "README.md",
        "LICENSE"
      ],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @url,
        "Documentation" => "https://hexdocs.pm/snappyrex"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      name: "Snappyrex",
      canonical: "http://hexdocs.pm/snappyrex",
      source_url: @url,
      extras: ["README.md", "LICENSE"]
    ]
  end
end
