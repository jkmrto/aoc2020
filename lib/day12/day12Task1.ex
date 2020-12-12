defmodule Aoc2020.Day12Task1 do
  def read(file) do
    file
    |> File.stream!([], :line)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split_at(&1, 1))
    |> Enum.map(fn {code, value} -> {code, elem(Integer.parse(value), 0)} end)
  end

  ######### -1,0 #######
  # 0, -1 ######## 0, 1 
  ######### 1, 0 #######

  def task1(file) do
    moves = read(file)
    origin = {0, 0}
    direction = {0, 1}

    apply_moves(moves, origin, direction)
  end

  def apply_moves([{"F", n} | rest], {py, px}, dirs = {dy, dx}) do
    apply_moves(rest, {py + dy * n, px + dx * n}, dirs)
  end

  def apply_moves([{"N", n} | rest], {py, px}, dirs) do
    apply_moves(rest, {py - n, px}, dirs)
  end

  def apply_moves([{"S", n} | rest], {py, px}, dirs) do
    apply_moves(rest, {py + n, px}, dirs)
  end

  def apply_moves([{"E", n} | rest], {py, px}, dirs) do
    apply_moves(rest, {py, px + n}, dirs)
  end

  def apply_moves([{"W", n} | rest], {py, px}, dirs) do
    apply_moves(rest, {py, px - n}, dirs)
  end

  def apply_moves([{code, n} | rest], pos, dirs) when code in ["R", "L"] do
    apply_moves(rest, pos, rotate(code, dirs, div(n, 90)))
  end

  def apply_moves([], pos, _dirs), do: pos

  def apply_moves([move | _], origin, dirs) do
    IO.puts("unexpeted movement: #{inspect(move)}, 
      origin: #{inspect(origin)},
      directin: #{inspect(dirs)}")
  end

  def rotate(_, dirs, 0), do: dirs
  def rotate("L", {-1, 0}, n), do: rotate("L", {0, -1}, n - 1)
  def rotate("L", {0, -1}, n), do: rotate("L", {1, 0}, n - 1)
  def rotate("L", {1, 0}, n), do: rotate("L", {0, 1}, n - 1)
  def rotate("L", {0, 1}, n), do: rotate("L", {-1, 0}, n - 1)

  def rotate("R", {-1, 0}, n), do: rotate("R", {0, 1}, n - 1)
  def rotate("R", {0, 1}, n), do: rotate("R", {1, 0}, n - 1)
  def rotate("R", {1, 0}, n), do: rotate("R", {0, -1}, n - 1)
  def rotate("R", {0, -1}, n), do: rotate("R", {-1, 0}, n - 1)
end
