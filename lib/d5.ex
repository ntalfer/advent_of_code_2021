defmodule D5 do
    def p1(file) do
        file
        |> File.read!()
        |> String.split("\n")
        |> Enum.reduce([], &build_vents_points/2)
        |> Enum.frequencies
        |> Enum.filter(fn {_k, v} -> v >= 2 end)
        |> length
        #|> Enum.reduce(%{}, &build_map/2)
        #|> IO.inspect
        #|> count_overlap
        #|> IO.inspect
    end

    defp build_vents_points(line, acc) do
        [p1, p2] = String.split(line, " -> ")
        [x1, y1] = String.split(p1, ",")
        [x2, y2] = String.split(p2, ",")
        [x1, y1, x2, y2] = Enum.map([x1, y1, x2, y2], &String.to_integer/1)
        cond do
            (x1 == x2) and (y2 < y1) ->
                Enum.map(y2..y1, fn y -> {x1, y} end) ++ acc
            x1 == x2 ->
                Enum.map(y2..y2, fn y -> {x1, y} end) ++ acc
            (y1 == y2) and (x2 < x1) ->
                Enum.map(x2..x1, fn x -> {x, y1} end) ++ acc
            y1 == y2 ->
                Enum.map(x1..x2, fn x -> {x, y1} end) ++ acc
            true ->
                #IO.inspect line
                #IO.inspect [x1, y1, x2, y2]
                acc
        end
    end

    defp build_map({x, y}, map) do
        case map[x][y] do
            nil -> put_in(map, [Access.key(x, %{}), y], 1)
            v -> put_in(map, [Access.key(x, %{}), y], v + 1)
        end
    end

    defp count_overlap(map) do
        IO.inspect map
        map
        |> Map.values
        |> Enum.map(&Map.values/1)
        |> List.flatten
        |> Enum.filter(&(&1 != 1))
        |> Enum.count
    end

    defp print_map(map) do
        IO.puts ""
        0..9
        |> Enum.each(fn y ->
            0..9
            |> Enum.reduce("", fn x, s ->
                case map[x][y] do
                    nil -> s <> "."
                    v -> s <> "#{v}"
                end
            end)
            |> IO.puts
        end)
        map
    end
end