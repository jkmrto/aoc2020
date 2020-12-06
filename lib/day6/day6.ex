defmodule Aoc2020.Day6 do
  def task1(file) do
    File.stream!(file, [])
    |> Enum.map(&String.trim/1)
    |> process_input_task1()
    |> Enum.map(&Enum.uniq/1)
    |> Enum.map(&Kernel.length/1)
    |> Enum.reduce(&(&1 + &2))
  end

  def process_input_task1(list), do: process_input_task1(list, [], [])
  def process_input_task1([], current, acc), do: [current | acc]

  def process_input_task1([line | rest], current, acc) do
    case line do
      "" -> process_input_task1(rest, [], [current | acc])
      _ -> process_input_task1(rest, String.graphemes(line) ++ current, acc)
    end
  end

  def task2(file) do
    File.stream!(file, [])
    |> Enum.map(&String.trim/1)
    |> process_input_task2()
    |> Enum.reduce(0, fn group, acc ->
      group
      |> Enum.flat_map(& &1)
      |> Enum.frequencies()
      |> Enum.filter(&(elem(&1, 1) == length(group)))
      |> Kernel.length()
      |> Kernel.+(acc)
    end)
  end

  def process_input_task2(list), do: process_input_task2(list, [], [])

  def process_input_task2([], current, acc), do: [current | acc]

  def process_input_task2([line | rest], current, acc) do
    case line do
      "" -> process_input_task2(rest, [], [current | acc])
      _ -> process_input_task2(rest, [String.graphemes(line) | current], acc)
    end
  end
end
