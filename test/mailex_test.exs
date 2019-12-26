defmodule MailexTest do
  use ExUnit.Case
  doctest Mailex

  test "greets the world" do
    assert Mailex.hello() == :world
  end
end
