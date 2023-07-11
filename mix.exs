defmodule Given.MixProject do
  use Mix.Project

  def project do
    [
      app: :given_exunit,
      description: "Feature testing extension for ExUnit",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      package: [
        licenses: ["MIT"],
        links: %{
          "GitHub" => "https://github.com/devstopfix/given-exunit"
        }
      ],
      source_url: "https://github.com/devstopfix/given-exunit",
      start_permanent: Mix.env() == :prod,
      version: "1.22.196"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:propcheck, "~> 1.4", only: [:test, :dev]}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
