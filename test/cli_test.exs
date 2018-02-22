defmodule CliTest do
    use ExUnit.Case
    doctest IssuesList

    import IssuesList.CLI, only: [parse_args: 1]

    test ":help returned by option parsing with -h and --help options" do
        assert parse_args(["-h", "other"]) == :help
        assert parse_args(["-help", "other"]) == :help
    end

    test "three values returned if three given" do
        assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
    end

    test "count is defaulted if two values given" do
        assert parse_args(["user", "project"]) == {"user", "project", 4}
    end

    test "none return value" do
        assert parse_args([]) == :none
    end




end
