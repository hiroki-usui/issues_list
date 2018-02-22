defmodule IssuesListTest do
  use ExUnit.Case
  doctest IssuesList

  test "calc add" do
    assert (1+1) == 2
  end

  test "greets the world" do
    assert IssuesList.hello() == :world
  end

end
