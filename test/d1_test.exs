defmodule D1Test do
  use ExUnit.Case

  test "p1" do
    assert D1.p1("test/d1_input.txt") == 1583
  end

  test "p2" do
    assert D1.p2("test/d1_input.txt") == 1627
  end
end
