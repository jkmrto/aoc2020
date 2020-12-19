defmodule Aoc2020.Day16 do
  def read(file) do
    file
    |> File.stream!([], :line)
    |> Enum.map(&String.trim/1)
    |> parse()
  end

  def max_occurrences(occurrences) do
    Enum.reduce(occurrences, 0, fn {_l, v}, acc ->
      if v > acc, do: v, else: acc
    end)
  end

  def task2(file) do
    {conds, nearby_tickets, your_ticket} = read(file)
    tickets = [your_ticket | nearby_tickets]

    tickets =
      tickets
      |> Enum.filter(fn ticket ->
        Enum.all?(ticket, fn {value, _pos} ->
          check_validity(value, conds)
        end)
      end)

    freqs =
      Enum.reduce(tickets, %{}, fn ticket, acc ->
        Enum.reduce(ticket, acc, fn {value, value_index}, acc ->
          Enum.reduce(conds, acc, fn {condition, cond_index}, acc ->
            if value in condition,
              do: Map.update(acc, cond_index, [value_index], &[value_index | &1]),
              else: acc
          end)
        end)
      end)
      |> Enum.map(fn {cond_pos, occurrences} -> {cond_pos, Enum.frequencies(occurrences)} end)

    free_positions = Enum.map(freqs, &elem(&1, 0))

    positions =
      run(freqs, free_positions, %{})
      |> Enum.into([])
      |> Enum.slice(0..5)
      |> Enum.map(&elem(&1, 1))

    your_ticket
    |> Enum.filter(&(elem(&1, 1) in positions))
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(&(&1 * &2))
  end

  def run(_freqs, [], register), do: register

  def run(freqs, free_positions, register) do
    {cond_index, value_index} = find_applicable_condition(freqs, free_positions)
    run(freqs, free_positions -- [value_index], Map.put(register, cond_index, value_index))
  end

  def find_applicable_condition([{cond_index, cond_ocurrences} | t], free_positions) do
    max = max_occurrences(cond_ocurrences)

    cond_ocurrences
    |> Enum.filter(fn {l, v} -> v == max && l in free_positions end)
    |> case do
      [{value_index, _value}] -> {cond_index, value_index}
      _ -> find_applicable_condition(t, free_positions)
    end
  end

  def task1(file) do
    {conds, tickets, _your_ticket} = read(file)

    Enum.map(tickets, fn ticket ->
      Enum.map(ticket, fn {value, _index} ->
        if check_validity(value, conds), do: true, else: value
      end)
    end)
    |> Enum.filter(fn res -> !Enum.all?(res, &(&1 == true)) end)
    |> Enum.map(fn list -> Enum.filter(list, &(&1 != true)) end)
    |> Enum.flat_map(& &1)
    |> Enum.sum()
  end

  def check_validity(value, [{range, _index} | conditions]) do
    cond do
      value in range -> true
      true -> check_validity(value, conditions)
    end
  end

  def check_validity(_value, []), do: false

  def parse(conds), do: parse(conds, {[], [], nil}, :conditions)
  def parse(["" | t], result, mode), do: parse(t, result, mode)
  def parse(["your ticket:" | t], result, _mode), do: parse(t, result, :your_ticket)
  def parse(["nearby tickets:" | t], result, _mode), do: parse(t, result, :nearby_tickets)

  def parse([h | t], {conditions, nearby_tickets, your_ticket}, :conditions) do
    condition =
      h
      |> String.split(": ")
      |> Enum.at(1)
      |> String.split(" or ")
      |> Enum.map(fn str ->
        String.split(str, "-")
        |> Enum.map(&String.to_integer(&1))
        |> (fn [l1, l2] -> Enum.to_list(l1..l2) end).()
      end)
      |> Enum.flat_map(& &1)

    parse(t, {[condition | conditions], nearby_tickets, your_ticket}, :conditions)
  end

  def parse([h | t], {conditions, nearby_tickets, your_ticket}, mode)
      when mode in [:your_ticket, :nearby_tickets] do
    ticket =
      h
      |> String.split(",")
      |> Enum.map(&String.to_integer(&1))

    case mode do
      :nearby_tickets -> parse(t, {conditions, [ticket | nearby_tickets], your_ticket}, mode)
      :your_ticket -> parse(t, {conditions, nearby_tickets, ticket}, mode)
    end
  end

  def parse([], {conditions, nearby_tickets, your_ticket}, _mode) do
    conditions =
      conditions
      |> Enum.reverse()
      |> Enum.with_index()

    nearby_tickets = Enum.map(nearby_tickets, &Enum.with_index(&1))
    your_ticket = Enum.with_index(your_ticket)

    {conditions, nearby_tickets, your_ticket}
  end
end
