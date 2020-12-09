defmodule Aoc2020.Day9 do
  def read(file) do
    file
    |> File.stream!([], :line)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&elem(Integer.parse(&1), 0))
  end

  def task1(file, preamble_size) do
    file
    |> read()
    |> find_invalid(preamble_size)
  end

  def task2(file, preamble_size) do
    read(file)
    |> (&find_range(&1, find_invalid(&1, preamble_size))).()
    |> (&(Enum.min(&1) + Enum.max(&1))).()
  end

  def find_range([h | t], looked_value), do: find_range([h], t, looked_value)

  def find_range(current_range, rest_list, looked_value) do
    sum = Enum.sum(current_range)

    cond do
      sum == looked_value ->
        current_range

      sum > looked_value ->
        find_range(tl(current_range), rest_list, looked_value)

      sum < looked_value ->
        find_range(current_range ++ [hd(rest_list)], tl(rest_list), looked_value)
    end
  end

  def find_invalid(list, preamble_size) do
    {preamble, not_preamble} = Enum.split(list, preamble_size)

    if check_rule(preamble, hd(not_preamble)) do
      find_invalid(tl(list), preamble_size)
    else
      hd(not_preamble)
    end
  end

  def check_rule([h | t], looked_sum) do
    if (looked_sum - h) in t, do: true, else: check_rule(t, looked_sum)
  end

  def check_rule([], _looked_sum), do: false
end
