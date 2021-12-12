defmodule D4 do
  def p1(file) do
    [draw | boards_list] =
      file
      |> File.read!()
      |> String.split("\n\n")

    boards = Enum.map(boards_list, &build_board/1)

    draw = draw |> String.split(",")
    {:win, n, board} = process_draw(draw, boards)
    p1_result(n, board)
  end

  defp p1_result(n, b) do
    size = length(Map.to_list(b))
    Enum.reduce(0..size-1, 0, fn x, s1 ->
        Enum.reduce(0..size-1, s1, fn y, s2 ->
            case b[x][y] do
                {v, false} ->
                    s2 + String.to_integer(v)
                _ ->
                    s2
            end
        end)
    end) * String.to_integer(n)
  end

  defp build_board(b) do
    b
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, " ", trim: true) end)
    |> do_build_board(%{}, 0)
  end

  defp do_build_board([], map, _) do
    map
  end
  defp do_build_board([line | lines], map, y) do
    new_map =
        line
        |> Enum.with_index
        |> Enum.reduce(map, fn {value, x}, m -> put_in(m, [Access.key(x, %{}) , y], {value, false}) end)
    do_build_board(lines, new_map, y + 1)
  end

  defp process_draw([], _) do
    :no_winner
  end
  defp process_draw([n | numbers], boards) do
    boards = Enum.map(boards, fn b -> do_process_draw(b, n) end)
    try do
        Enum.each(boards, &win?/1)
        process_draw(numbers, boards)
    catch
        {:win, board} ->
            {:win, n, board}
    end
  end

  def do_process_draw(b, n) do
    size = length(Map.to_list(b))
    Enum.reduce(0..size-1, b, fn x, b1 ->
        Enum.reduce(0..size-1, b1, fn y, b2 ->
            case b2[x][y] do
                {^n, _} ->
                    put_in(b2, [Access.key(x, %{}) , y], {n, true})
                _ ->
                    b2
            end
        end)
    end)
  end

  def win?(b) do
    size = length(Map.to_list(b))
    # rows
    for x <- 0..size-1 do
        win? =
        Enum.reduce(0..size-1, true,
        fn y, bool ->
            {_, checked} = b[x][y]
            bool and checked
        end)
        if win?, do: throw({:win, b})
    end
    # columns
    for y <- 0..size-1 do
        win? =
        Enum.reduce(0..size-1, true,
        fn x, bool ->
            {_, checked} = b[x][y]
            bool and checked
        end)
        if win?, do: throw({:win, b})
    end
  end
end
