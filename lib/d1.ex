defmodule D1 do
  def p1(file) do
    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> count_increases(nil, 0)
  end

  defp count_increases([], _, count) do
    count
  end

  defp count_increases([val | rest], prev_val, count)
       when is_integer(prev_val) and val > prev_val do
    count_increases(rest, val, count + 1)
  end

  defp count_increases([val | rest], _, count) do
    count_increases(rest, val, count)
  end

  def p2(file) do
    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> build_windows([])
    |> count_increases(nil, 0)
  end

  defp build_windows([val1, val2, val3 | rest], acc) do
    sum = val1 + val2 + val3
    build_windows([val2, val3 | rest], [sum|acc])
  end
  defp build_windows(_, acc) do
    :lists.reverse(acc)
  end
end
