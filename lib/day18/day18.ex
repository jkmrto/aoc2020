defmodule Aoc2020.Day18 do
  def read(file) do
    file
    |> File.stream!([], :line)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&resolve(&1))
    |> Enum.sum()
  end

  def resolve(str) do
    str
    |> String.replace(" ", "")
    |> String.graphemes()
    |> process()
  end

  def split_by_closing_bracket([")" | rest], acc, 1) do
    {Enum.reverse(acc), rest}
  end

  def split_by_closing_bracket([")" | rest], acc, n),
    do: split_by_closing_bracket(rest, [")" | acc], n - 1)

  def split_by_closing_bracket(["(" | rest], acc, n),
    do: split_by_closing_bracket(rest, ["(" | acc], n + 1)

  def split_by_closing_bracket([char | rest], acc, n),
    do: split_by_closing_bracket(rest, [char | acc], n)

  def process(list) do
    {arg, rest} = pick_argument(list)
    f(arg, rest)
  end

  def f(arg1, []), do: arg1

  def f(arg1, rest) do
    [op | rest_after_op] = rest
    {arg2, rest_after_arg2} = pick_argument(rest_after_op)
    f(calc(arg1, arg2, op), rest_after_arg2)
  end

  def calc(arg1, arg2, "+"), do: arg1 + arg2
  def calc(arg1, arg2, "*"), do: arg1 * arg2

  def pick_argument(["(" | rest]) do
    {arg1, rest} = split_by_closing_bracket(rest, [], 1)
    {process(arg1), rest}
  end

  def pick_argument([value | rest]) do
    {String.to_integer(value), rest}
  end
end
