defmodule IssuesList.CLI do

    import IssuesList.TableFormatter, only: [print_table_for_columns: 2]

    require Logger

    @default_count 4

    @moduledoc"""
    Handle the Command line parsing and the dispatch to
    the various functions that end up generating a
    table of the last _n_ issues in a github project
    """

    def main(argv) do

        Logger.debug(fn -> "this is debug log." end)
        Logger.info(fn -> "this is info log." end)
        Logger.warn(fn -> "this is warn log." end)
        Logger.error(fn -> "this is error log." end)

        #IO.puts("--- start [IssuesList.CLI # run] ---")

        argv
        |> parse_args
        |> process
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
        IO.puts("  *** parameter[user:#{user}, project:#{project}, count:#{count}]")

        IssuesList.GithubIssues.fetch(user, project)
        |> decode_response
        |> convert_to_list_of_maps
        |> sort_into_aasending_order
        |> Enum.take(count)
        |> print_table_for_columns(["number", "created_at", "title"])
    end

    def decode_response({:ok, body_data}), do: body_data

    def decode_response({:error, error_data}) do
        #{_, message} = List.keyfind(error_data, "message", 0)
        IO.puts "Error fetching from GitHub: #{error_data["message"]}"
        System.halt(2)
    end

    @doc"""
    キーワードリストをMapに変換する
    """
    def convert_to_list_of_maps(list) do
        #IO.puts("  *** called [convert_to_list_of_maps]")
        list
        |> Enum.map(&Enum.into(&1, Map.new))
    end

    @doc"""
    日付順に並び替えを行う
    """
    def sort_into_aasending_order(issues_list) do
        Enum.sort(issues_list, fn i1 , i2 -> i1["created_at"] <= i2["created_at"] end)
    end

end