defmodule D2Test do
  use ExUnit.Case

  test "p1" do
    assert D2.p1("test/d2_input.txt") == 1_488_669
  end

  test "p2 example" do
    assert D2.p2("test/d2_example.txt") == 900
  end

  test "p2" do
    assert D2.p2("test/d2_input.txt") == 1176514794
  end
end
