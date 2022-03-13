defmodule D5Test do
  use ExUnit.Case

  test "p1 example" do
    assert D5.p1("test/d5_example.txt") == 5
  end

  test "p1" do
    assert D5.p1("test/d5_input.txt") == 3586
  end

  test "p2" do
    # assert D4.p2("test/d4_input.txt") == 65550
  end
end
