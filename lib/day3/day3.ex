defmodule Aoc2020.Day3 do
  @down 1
  @right 3

  def read_field(file) do
    File.stream!(file, [], :line)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn row ->
      row
      |> String.graphemes()
      |> Stream.with_index()
      |> Stream.map(fn {row, i} -> {i, row} end)
      |> Map.new()
    end)
  end

  def run(field, {down, right}) do
    width = field |> hd() |> Map.keys() |> length()

    field
    |> Enum.take_every(down)
    |> Enum.reduce({0, 0}, fn row, {x_pos, trees} ->
      case Map.get(row, Integer.mod(x_pos, width)) do
        "#" ->
          {x_pos + right, trees + 1}

        "." ->
          {x_pos + right, trees}
      end
    end)
    |> elem(1)
  end

  def task1(file) do
    field = read_field(file)
    run(field, {@down, @right})
  end

  def task2(file) do
    field = read_field(file)
    run(field, {@down, @right})

    slopes = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

    Enum.reduce(slopes, 1, fn {right, down}, mult ->
      mult * run(field, {down, right})
    end)
  end
end
