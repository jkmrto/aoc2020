defmodule Aoc2020.Day2 do
  defmodule Password do
    defstruct [:repetitions, :char, :password]
  end

  def read(file) do
    File.stream!(file, [], :line)
    |> Enum.map(&String.trim/1)
  end

  def parser(line) do
    [repetions, char, pwd] = String.split(line, " ")

    %Password{
      password: String.graphemes(pwd),
      repetitions:
        String.split(repetions, "-")
        |> Enum.map(&(Integer.parse(&1) |> elem(0)))
        |> List.to_tuple(),
      char: String.split(char, ":") |> hd()
    }
  end

  def task1(file) do
    file
    |> read()
    |> Enum.map(&parser(&1))
    |> Enum.map(fn pwd ->
      counter(pwd.password, pwd.char, elem(pwd.repetitions, 0), elem(pwd.repetitions, 1), 0)
    end)
    |> Enum.filter(fn {valid} -> valid == :valid end)
    |> Kernel.length()
  end

  def counter([v | rest], char, min_rep, max_rep, previous_rep) do
    current_rep = if v == char, do: previous_rep + 1, else: previous_rep

    cond do
      current_rep > max_rep ->
        {:invalid}

      true ->
        counter(rest, char, min_rep, max_rep, current_rep)
    end
  end

  def counter([], _char, min_rep, _max_rep, total_rep) do
    if total_rep >= min_rep, do: {:valid}, else: {:unvalid}
  end

  def task2(file) do
    file
    |> read()
    |> Enum.map(&parser(&1))
    |> Enum.filter(fn %{repetitions: {p1, p2}, char: char, password: pwd} ->
      Enum.at(pwd, p1 - 1) == char != (Enum.at(pwd, p2 - 1) == char)
    end)
    |> Kernel.length()
  end
end
