defmodule TableFormatterTest do
    use ExUnit.Case
    doctest IssuesList
    import ExUnit.CaptureIO

    alias IssuesList.TableFormatter, as: TF

    defp get_simpletest_data do
        [
            [c1: "r1 c1", c2: "r1 c2",  c3: "r1 c3", c4: "r1++++++r4"],
            [c1: "r2 c1", c2: "r2 c2",  c3: "r2 c3", c4: "r2 4"],
            [c1: "r3 c1", c2: "r3 c2",  c3: "r3 c3", c4: "r3 4"],
            [c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 4"],
        ]
    end

    defp get_headers, do: [:c1, :c2, :c4]

    defp split_with_three_columns do
        TF.split_into_columns(get_simpletest_data(), get_headers())
    end

    test "split_with_three_columns" do
        IO.puts("  *** called split_with_three_columns.")
        columns = split_with_three_columns()
        assert length(columns) == length(get_headers())
        assert List.first(columns) == ["r1 c1", "r2 c1", "r3 c1", "r4 c1"]
        assert List.last(columns) == ["r1++++++r4", "r2 4", "r3 4", "r4 4"]
    end

    test "column_width" do
        widths = TF.width_of(split_with_three_columns())
        assert widths == [5, 6, 10]
    end

    test "correct format string returned" do
        assert TF.format_for([9,10,11]) == "~9s|~10s|~11s~n"
    end

    test "out put is correct" do
        result = capture_io(fn -> TF.print_table_for_columns(get_simpletest_data(), get_headers()) end)
        assert result == """
          c1|    c2|        c4
       -----+-------+----------
       r1 c1| r1 c2|r1++++++r4
       r2 c1| r2 c2|      r2 4
       r3 c1| r3 c2|      r3 4
       r4 c1|r4++c2|      r4 4
       """
    end

end
