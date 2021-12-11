defmodule D3 do
  def p1(file) do
    lines =
      file
      |> File.read!()
      |> String.split("\n")

    # gamma: most common
    # epsilon : least common
    %{gamma: gamma, epsilon: epsilon} = fetch_data(lines)
    gamma * epsilon
  end

  def p2(file) do
    lines =
      file
      |> File.read!()
      |> String.split("\n")

    #IO.inspect(lines)

    o_r = fetch_o_rating(lines, 0)

    co2_r = fetch_co2_rating(lines, 0)
    #IO.inspect o_r
    #IO.inspect co2_r
    o_r * co2_r
  end

  defp fetch_o_rating(lines, index) do
    len = lines |> Enum.at(0) |> String.length()
    %{gamma: gamma} = fetch_data(lines)
    criteria = gamma |> Integer.to_string(2) |> String.pad_leading(len, "0") |> String.at(index)

    lines
    |> Enum.filter(fn line -> criteria == String.at(line, index) end)
    |> case do
      [res] ->
        {val, _} = Integer.parse(res, 2)
        val

      new_lines ->
        fetch_o_rating(new_lines, index + 1)
    end
  end

  defp fetch_co2_rating(lines, index) do
    len = lines |> Enum.at(0) |> String.length()
    %{epsilon: epsilon} = fetch_data(lines)
    #IO.inspect epsilon |> Integer.to_string(2)
    criteria = epsilon |> Integer.to_string(2) |> String.pad_leading(len, "0") |> String.at(index)
    #IO.puts  "index = #{index} - criteria = #{criteria}"
    #IO.puts "lines = #{inspect lines}"

    lines
    |> Enum.filter(fn line -> criteria == String.at(line, index) end)
    |> case do
      [res] ->
        {val, _} = Integer.parse(res, 2)
        val

      new_lines ->
        fetch_co2_rating(new_lines, index + 1)
    end
  end

  defp fetch_data(lines) do
    line_len = lines |> Enum.at(0) |> String.length()
    ref = :counters.new(line_len, [])

    lines
    |> Enum.each(fn line -> handle_line(line, ref) end)

    1..line_len
    |> Enum.reduce(
      %{gamma: 0, epsilon: 0, ref: ref, lines: lines},
      fn index, %{gamma: gamma, epsilon: epsilon} = acc ->
        cond do
          :counters.get(ref, index) >= 0 ->
            %{acc | gamma: gamma + Bitwise.bsl(1, line_len - index)}

          true ->
            %{acc | epsilon: epsilon + Bitwise.bsl(1, line_len - index)}
        end
      end
    )
  end

  defp handle_line(line, ref) do
    line
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.each(fn {char, index} ->
      case char do
        ?0 ->
          :ok = :counters.sub(ref, index + 1, 1)

        ?1 ->
          :ok = :counters.add(ref, index + 1, 1)
      end
    end)
  end
end
