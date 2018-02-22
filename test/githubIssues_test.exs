defmodule GithubIssuesTest do
    use ExUnit.Case
    doctest IssuesList

    import IssuesList.GithubIssues, only: [get_issues_url: 2, handle_response: 1]

    test "get github url with user and project" do
        assert get_issues_url("hiroki-usui", "sample") == "https://api.github.com/repos/hiroki-usui/sample/issues"
    end

    test "handle response patern [ok, error]" do
        assert handle_response({ :ok, %{status_code: 200, body: "ok response"} }) == {:ok, "ok response"}
        assert handle_response({ :NG, %{status_code: 404, body: "not found"} }) == {:error, "not found"}
    end

end