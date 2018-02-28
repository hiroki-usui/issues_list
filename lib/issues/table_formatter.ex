defmodule IssuesList.TableFormatter do

    import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

    @doc"""
    パラメータの行データを出力する
    パラメータのヘッダー情報をもとに出力
    正常終了時の戻り値は「:ok」
    """
    def print_table_for_columns(rows, headers) do
        with data_by_columns = split_into_columns(rows, headers),
             column_widths = width_of(data_by_columns),
             format = format_for(column_widths)
        do
            puts_one_line_in_columns(headers, format)
            IO.puts(separator(column_widths))
            puts_in_columns(data_by_columns, format)
        end
    end

    @doc"""
    headersに指定されたkeyに該当データをrowから抽出する
    """
    def split_into_columns(rows, headers) do
        for header <- headers do
            for row <- rows do
                printable(row[header])
            end
        end
    end

    @doc"""
    文字列への変換
    """
    def printable(str) when is_binary(str), do: str

    def printable(str), do: to_string(str)

    @doc"""
    columnsに含まれるデータの最大桁数を抽出する
    """
    def width_of(columns) do
        for column <- columns do
            column
            |> map(&String.length/1)
            |> max
        end
    end

    @doc"""
    行の出力フォーマットを決める（例："~3s|~4s~n"）
    """
    def format_for(column_widths) do
        map_join(column_widths, "|", fn width -> "~#{width}s" end) <> "~n"
    end

    def separator(column_widths) do
#        map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
        map_join(column_widths, "+", fn width -> List.duplicate("-", width) end)
    end

    def puts_in_columns(data_by_columns, format) do
        data_by_columns
        |> List.zip
        |> map(&Tuple.to_list/1)
        |> each(&puts_one_line_in_columns(&1, format))
    end

    def puts_one_line_in_columns(fields, format) do
        :io.format(format, fields)
    end
end