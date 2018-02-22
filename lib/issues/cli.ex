defmodule IssuesList.CLI do
    
    @default_count 4

    @moduledoc"""
    Handle the Command line parsing and the dispatch to
    the various functions that end up generating a
    table of the last _n_ issues in a github project
    """

    def run(argv) do

        IO.puts("--- start [IssuesList.CLI # run] ---")

        argv
        |> parse_args
        |> process

        IO.puts("--- end [IssuesList.CLI # run] ---")

    end

    @doc"""
    'argv' can be -h or --help, which returns :help

    Otherwise it is a github user name, project name, and (optionally)
    the number of entries to format.
    Return a tuple of '{ user, project, count}', or ':help' if help was given 
    """
    def parse_args(argv) do
        parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

        # help、 ユーザとプロジェクト指定、
        case parse do
            {[help: true], _other01, _other02}
                -> :help
            {_other01, [user, project, count], _other02}
                -> {user, project, String.to_integer(count)}
    
            {_othe01r, [user, project], _other02}
                -> {user, project, @default_count}
            
            _other
                -> :none
        end

    end


    def process(:none) do
        IO.puts("bye!")
        System.halt(0)
    end

    def process(:help) do
        IO.puts """
        usage issues <user> <project> [count | #{@default_count}]
        """
        System.halt(0)
    end

    def process({user, project, count}) do
        IO.puts """
        now creating.
        parameter[user:#{user}, project:#{project}, count:#{count}]
        """
        IssuesList.GithubIssues.fetch(user, project)
        |> decode_response

        :ok
    end

    def decode_response({:ok, response_data}) do
        response_data
    end

    def decode_response({:error, response_data}) do
        #{_, message} = List.keyfind(error_data, "message", 0)
        IO.puts "Error fetching from GitHub: #{message["message"]}"
        System.halt(2)
    end

end