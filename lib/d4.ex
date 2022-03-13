defmodule D4 do
  def p1(file) do
    [draw | boards_list] =
      file
      |> File.read!()
      |> String.split("\n\n")

    boards = build_boards(boards_list, [], 0)

    draw = draw |> String.split(",")
    {:win, n, _, board} = process_draw(draw, boards)
    #IO.puts "got a winner when drawing #{n}"
    result(n, board)
  end

  defp result(n, b) do
    size = length(Map.to_list(b)) - 1

    Enum.reduce(0..(size - 1), 0, fn x, s1 ->
      Enum.reduce(0..(size - 1), s1, fn y, s2 ->
        case b[x][y] do
          {v, false} ->
            s2 + String.to_integer(v)

          _ ->
            s2
        end
      end)
    end) * String.to_integer(n)
  end

  def p2(file) do
    [draw | boards_list] =
      file
      |> File.read!()
      |> String.split("\n\n")

    boards = build_boards(boards_list, [], 0)

    draw = draw |> String.split(",")
    {n, board} = last_winner_board(draw, boards, [])
    #IO.inspect board
    result(n, board)
  end


  defp last_winner_board(draw, boards, winners) do
    case process_draw(draw, boards) do
        {:win, n, new_numbers, %{"index" => index} = b} ->
            #IO.puts "board #{index} wins!"
            remaining = Enum.filter(boards, fn b -> b["index"] != index end)
            winner = {n, b}
            last_winner_board(new_numbers, remaining, [winner|winners])
        :no_winner ->
            #IO.puts "no_winner"
            [last_winner|_] = winners
            last_winner
    end
  end

  defp build_boards([], acc, _) do
    acc
  end

  defp build_boards([b | boards], acc, index) do
    new_b =
      b
      |> String.split("\n")
      |> Enum.map(fn line -> String.split(line, " ", trim: true) end)
      |> do_build_board(%{"index" => index}, 0)

    new_acc = [new_b | acc]
    build_boards(boards, new_acc, index + 1)
  end

  defp do_build_board([], map, _) do
    map
  end

  defp do_build_board([line | lines], map, y) do
    new_map =
      line
      |> Enum.with_index()
      |> Enum.reduce(map, fn {value, x}, m ->
        put_in(m, [Access.key(x, %{}), y], {value, false})
      end)

    do_build_board(lines, new_map, y + 1)
  end

  defp process_draw([], _) do
    :no_winner
  end

  defp process_draw([n | numbers], boards) do
    #IO.inspect "drawing #{n}"
    boards = Enum.map(boards, fn b -> do_process_draw(b, n) end)

    try do
      Enum.each(boards, &win?/1)
      process_draw(numbers, boards)
    catch
      {:win, board} ->
        #IO.puts "board #{board["index"]} wins"
        {:win, n, numbers, board}
    end
  end

  def do_process_draw(b, n) do
    size = length(Map.to_list(b)) - 1

    Enum.reduce(0..(size - 1), b, fn x, b1 ->
      Enum.reduce(0..(size - 1), b1, fn y, b2 ->
        case b2[x][y] do
          {^n, _} ->
            put_in(b2, [Access.key(x, %{}), y], {n, true})

          _ ->
            b2
        end
      end)
    end)
  end

  def win?(b) do
    size = length(Map.to_list(b)) - 1
    # rows
    for x <- 0..(size - 1) do
      win? =
        Enum.reduce(0..(size - 1), true, fn y, bool ->
          {_, checked} = b[x][y]
          bool and checked
        end)

      if win?, do: throw({:win, b})
    end

    # columns
    for y <- 0..(size - 1) do
      win? =
        Enum.reduce(0..(size - 1), true, fn x, bool ->
          {_, checked} = b[x][y]
          bool and checked
        end)

      if win?, do: throw({:win, b})
    end
  end
end
