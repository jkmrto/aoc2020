defmodule Aoc2020.Day16 do
  def read(file) do
    file
    |> File.stream!([], :line)
    |> Enum.map(&String.trim/1)
    |> parse({[], []}, :conditions)
  end

  def task1(file) do
    {conds, tickets} = read(file)

    Enum.map(tickets, fn ticket ->
      Enum.map(
        ticket,
        fn value ->
          check_validity(value, conds)
        end
      )
    end)
    |> Enum.filter(fn res -> !Enum.all?(res, &(&1 == true)) end)
    |> Enum.map(fn list -> Enum.filter(list, &(&1 != true)) end)
    |> Enum.flat_map(& &1)
    |> Enum.sum()
  end

  def parse(["" | t], result, mode), do: parse(t, result, mode)
  def parse(["your ticket:" | t], result, _mode), do: parse(t, result, :your_ticket)
  def parse(["nearby tickets:" | t], result, _mode), do: parse(t, result, :nearby_tickets)
  def parse([_ | t], result, :your_ticket), do: parse(t, result, :your_ticket)

  def parse([h | t], {conditions, tickets}, :conditions) do
    condition =
      h
      |> String.split(": ")
      |> Enum.at(1)
      |> String.split(" or ")
      |> Enum.map(fn str ->
        String.split(str, "-")
        |> Enum.map(&String.to_integer(&1))
        |> List.to_tuple()
      end)

    parse(t, {[condition | conditions], tickets}, :conditions)
  end

  def parse([h | t], {conditions, tickets}, :nearby_tickets) do
    ticket =
      h
      |> String.split(",")
      |> Enum.map(&String.to_integer(&1))

    parse(t, {conditions, [ticket | tickets]}, :nearby_tickets)
  end

  def parse([], result, _mode), do: result

  def check_validity(value, [[{l1a, l1b}, {l2a, l2b}] | t]) do
    cond do
      value >= l1a and value <= l1b -> true
      value >= l2a and value <= l2b -> true
      true -> check_validity(value, t)
    end
  end

  def check_validity(value, []), do: value
end
