defmodule ContentfulElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :contentful_elixir,
      version: "0.3.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "ContentfulElixir",
      docs: [
        main: "ContentfulElixir",
        extras: ["README.md"]
      ]
    ]
  end

  defp description() do
    "Elixir wrapper for Contentful calls with LiveView rendering components"
  end

  defp package do
    %{
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Oliphaunte/contentful_elixir"}
    }
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
      {:req, "~> 0.4.0"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
