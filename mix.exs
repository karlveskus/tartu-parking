defmodule TartuParking.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tartu_parking,
      applications: [:timex],
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: [
        "white_bread.run": :test
      ],
      test_coverage: [
        tool: Coverex.Task,
        ignore_modules: [
          TartuParking.ChannelCase,
          TartuParking.ConnCase,
          TartuParking.Router.Helpers,
          TartuParking.Gettext,
          TartuParking.PostgresTypes
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {TartuParking, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:coverex, "~> 1.4.10", only: :test, runtime: false},
      {:cowboy, "~> 1.0"},
      {:geo, "~> 2.0"},
      {:geo_postgis, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:hound, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:pbkdf2_elixir, "~> 0.12"},
      {:canary, "~> 1.1.1"},
      {:guardian, "~> 0.14"},
      {:mock, "~> 0.2.0", only: :test},
      {:ex_machina, "~> 2.1", only: :test},
      {:faker, "~> 0.9", only: :test},
      {:httpoison, "~> 0.13"},
      {:phoenix, "~> 1.3.0-rc"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:timex, "~> 3.0"},
      {:white_bread, "~> 4.1", only: [:test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
