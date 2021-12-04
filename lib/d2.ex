defmodule D2 do
  def p1(file) do
    p1_res = fn %{x: x, d: d} -> x * d end

    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.reduce(%{x: 0, d: 0}, &handle_commands/2)
    |> p1_res.()
  end

  defp handle_commands(command, %{x: x, d: d} = pos) do
    [cmd, delta_str] = String.split(command)
    delta = String.to_integer(delta_str)

    case cmd do
      "down" -> %{pos | d: d + delta}
      "up" -> %{pos | d: d - delta}
      "forward" -> %{pos | x: x + delta}
    end
  end

  def p2(file) do
    p2_res = fn %{x: x, d: d} -> x * d end

    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.reduce(%{x: 0, d: 0, aim: 0}, &handle_commands_p2/2)
    |> p2_res.()
  end

  defp handle_commands_p2(command, %{x: x, d: d, aim: aim} = pos) do
    [cmd, delta_str] = String.split(command)
    delta = String.to_integer(delta_str)

    case cmd do
      "down" -> %{pos | aim: aim + delta}
      "up" -> %{pos | aim: aim - delta}
      "forward" -> %{pos | x: x + delta, d: d + (aim * delta)}
    end
  end
end
