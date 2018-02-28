defmodule IssuesList.MixProject do
  use Mix.Project

  def project do
    [
      app:             :issues_list,
      version:         "0.1.0",
      elixir:          "~> 1.6",
      name:            "IssuesList",
      source_url:      "https://github.com/hiroki-usui/issues_list",
      escript:         escript_config,
      start_permanent: Mix.env() == :prod,
      deps:            deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :ex_doc,     "~> 0.16"},
      { :earmark,    ">= 0.0.0"},
      { :httpoison,  "~> 1.0" },
      { :poison,     "~> 3.1"}
    ]
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
  end

  # escriptが実行するmainモジュールを指定
  def escript_config do
    [main_module: IssuesList.CLI]
  end

end
