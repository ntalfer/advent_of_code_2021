defmodule D4Test do
    use ExUnit.Case

    # test "p1 example" do
    #   assert D3.p1("test/d3_example.txt") == 198
    # end

    test "p1" do
      assert D4.p1("test/d4_input.txt") == 33462
    end

    # test "p2 example" do
    #   assert D3.p2("test/d3_example.txt") == 230
    # end

    # test "p2" do
    #   assert D3.p2("test/d3_input.txt") == 4_856_080
    # end
  end