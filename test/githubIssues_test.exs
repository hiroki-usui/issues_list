defmodule GithubIssuesTest do
    use ExUnit.Case
    doctest IssuesList

    import IssuesList.GithubIssues, only: [get_issues_url: 2, handle_response: 1]

    test "get github url with user and project" do
        assert get_issues_url("hiroki-usui", "sample") == "https://api.github.com/repos/hiroki-usui/sample/issues"
    end

    test "handle response patern [ok, error]" do
        IO.puts("  *** start : handle response patern [ok, error]")
        assert handle_response(%HTTPoison.Response{status_code: 200, body: ~s({"name": "Devin Torres"})} ) == {:ok, %{"name" => "Devin Torres"}}
        assert handle_response(%HTTPoison.Response{status_code: 404, body: ~s({"message": "error"})} ) == {:error, %{"message" => "error"}}
    end

end