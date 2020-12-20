defmodule Aoc2020.Day18 do
  def task2(file) do
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
    |> apply()
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

  def apply({arg1, arg2, op}) when is_integer(arg1) and is_integer(arg2) do
    calc(arg1, arg2, op)
  end

  def apply({arg1, arg2, op}) when is_integer(arg1) do
    calc(arg1, apply(arg2), op)
  end

  def apply({arg1, arg2, op}) when is_integer(arg2) do
    calc(apply(arg1), arg2, op)
  end

  def apply({arg1, arg2, op}) do
    calc(apply(arg1), apply(arg2), op)
  end

  def f(arg1, []), do: arg1

  def f(arg1, rest) do
    [op | rest_after_op] = rest
    {arg2, rest_after_arg2} = pick_argument(rest_after_op)

    case op do
      "*" -> {arg1, f(arg2, rest_after_arg2), op}
      "+" -> f({arg1, arg2, op}, rest_after_arg2)
    end
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
