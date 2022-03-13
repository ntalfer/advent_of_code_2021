defmodule D4Test do
    use ExUnit.Case

    test "p1" do
      assert D4.p1("test/d4_input.txt") == 33462
    end

    test "p1 example" do
        assert D4.p1("test/d4_example.txt") == 4512
    end

    test "p2" do
      assert D4.p2("test/d4_input.txt") == 65550
    end
  end