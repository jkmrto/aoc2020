defmodule Aoc2020.Day12Task2 do
  def read(file) do
    file
    |> File.stream!([], :line)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split_at(&1, 1))
    |> Enum.map(fn {code, value} -> {code, elem(Integer.parse(value), 0)} end)
  end

  def rotate(_, waypoint, 0), do: waypoint
  def rotate("R", {wy, wx}, n), do: rotate("R", {wx, -wy}, n - 1)
  def rotate("L", {wy, wx}, n), do: rotate("L", {-wx, wy}, n - 1)

  def task2(file) do
    moves = read(file)
    origin = {0, 0}
    waypoint = {-1, 10}

    apply_moves(moves, origin, waypoint)
    |> (fn {x, y} -> abs(x) + abs(y) end).()
  end

  def apply_moves([{"F", n} | rest], {py, px}, waypoint = {dy, dx}) do
    apply_moves(rest, {py + dy * n, px + dx * n}, waypoint)
  end

  def apply_moves([{"N", n} | rest], pos, {dy, dx}), do: apply_moves(rest, pos, {dy - n, dx})
  def apply_moves([{"S", n} | rest], pos, {dy, dx}), do: apply_moves(rest, pos, {dy + n, dx})
  def apply_moves([{"E", n} | rest], pos, {dy, dx}), do: apply_moves(rest, pos, {dy, dx + n})
  def apply_moves([{"W", n} | rest], pos, {dy, dx}), do: apply_moves(rest, pos, {dy, dx - n})

  def apply_moves([{code, n} | rest], pos, waypoint) when code in ["R", "L"] do
    rotation = rotate(code, waypoint, div(n, 90))
    apply_moves(rest, pos, rotation)
  end

  def apply_moves([move | _], origin, waypoint) do
    IO.puts("unexpeted movement: #{inspect(move)}, 
      origin: #{inspect(origin)},
      waypoint: #{inspect(waypoint)}")
  end

  def apply_moves([], pos, _dirs), do: pos
end
