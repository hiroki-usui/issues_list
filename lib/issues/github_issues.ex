defmodule IssuesList.GithubIssues do

    # user agentは何でもよさそう
    @user_agent [ {"user-agent", "Mozilla/5.0"}]

    #githubのURL
    @github_url Application.get_env(:issues_list, :github_url)

    @moduledoc"""
    get Issues list from Github 
    """

    @doc"""
    GitHubからissues一覧を取得する戻り値は処理結果とbodyのタプル
    """
    def fetch(user, project) do

        #IO.puts("  ***1 #{@github_url}")
        IO.puts("  ***2 #{get_issues_url(user, project)}")

        get_issues_url(user, project)
        |> HTTPoison.get(@user_agent)
        |> handle_response
    end

    def get_issues_url(user, project), do: "#{@github_url}/repos/#{user}/#{project}/issues"

    # 1.0.0での戻り値
    def handle_response(%HTTPoison.Response{status_code: 200, body: body_data}) do
        #IO.puts("  *** staus 200")
        {:ok, Poison.Parser.parse!(body_data)}
    end

    def handle_response(%HTTPoison.Response{status_code: _status_code, body: body_data}) do
        #IO.puts("  *** staus #{status_code_val}")
        {:error, Poison.Parser.parse!(body_data)}
    end

    # 旧バージョン戻り値
    def handle_response({ :ok, %{status_code: 200, body: body_data} }) do
        IO.puts("  *** old version [ok]")
        {:ok, Poison.Parser.parse!(body_data)}
    end

    def handle_response( {_other, %{status_code: _code, body: body_data} }) do
        IO.puts("  *** old version [error]")
        {:error, Poison.Parser.parse!(body_data)}
    end

end