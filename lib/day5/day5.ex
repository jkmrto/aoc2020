defmodule Aoc2020.Day5 do
  def read(file) do
    File.stream!(file, [], :line)
    |> Enum.map(&String.trim/1)
  end

  def get_ID(code) do
    {row_code, column_code} = String.split_at(code, 7)

    {row, _} =
      row_code
      |> String.replace("F", "0")
      |> String.replace("B", "1")
      |> Integer.parse(2)

    {column, _} =
      column_code
      |> String.replace("L", "0")
      |> String.replace("R", "1")
      |> Integer.parse(2)

    row * 8 + column
  end

  def task1(file) do
    file
    |> read()
    |> Enum.map(&get_ID(&1))
    |> Enum.max()
  end

  def task2(file) do
    file
    |> read()
    |> Enum.map(&get_ID(&1))
    |> Enum.sort()
    |> Enum.chunk_every(2)
    |> Enum.filter(fn [x, y] -> y - x == 2 end)
    |> Enum.map(&(hd(&1) + 1))
  end
end
