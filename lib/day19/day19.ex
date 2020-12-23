defmodule Aoc2020.Day19 do
  def read(file) do
    file
    |> File.stream!([], :line)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce({%{}, []}, fn row, {rules, msgs} ->
      case String.split(row, ": ") do
        [rule_id, rules_combs] ->
          rule_id = String.to_integer(rule_id)
          processed_combs = proccess_rules(rules_combs)
          {Map.put(rules, rule_id, processed_combs), msgs}

        [""] ->
          {rules, msgs}

        [msg] ->
          {rules, [msg | msgs]}
      end
    end)
  end

  def proccess_rules(v) when v in ["\"a\"", "\"b\""], do: [String.replace(v, "\"", "")]

  def proccess_rules(rule_combs) do
    rule_combs
    |> String.split("|")
    |> Enum.map(&String.trim(&1))
    |> Enum.map(fn rule ->
      rule
      |> String.split(" ")
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  def task1(file) do
    {pending_rules, msgs} = read(file)
    result = run(pending_rules, %{})

    msgs
    |> Enum.filter(&(&1 in result))
    |> Enum.count()
  end

  def run(%{}, %{0 => result}), do: MapSet.new(result)

  def run(pending_rules, resolved_rules) do
    {id, value} =
      pending_rules
      |> Enum.into([])
      |> retrieve_rule(resolved_rules)

    run(
      Map.drop(pending_rules, [id]),
      Map.put(resolved_rules, id, value)
    )
  end

  def retrieve_rule([{rule_id, [rule_value]} | _rest], _resolved)
      when is_binary(rule_value) do
    {rule_id, [rule_value]}
  end

  def retrieve_rule([{rule_id, rule_combs} | rest], resolved_rules) do
    cond do
      is_resolvable?(rule_combs, resolved_rules) ->
        {rule_id, develop_rules(rule_combs, resolved_rules)}

      true ->
        retrieve_rule(rest, resolved_rules)
    end
  end

  def is_recursive_resolvable?() do
  end

  def is_resolvable?(rule_combs, resolved_rules) do
    resolved_rules = Map.keys(resolved_rules)

    rule_combs
    |> Enum.flat_map(& &1)
    |> Enum.all?(fn v -> v in resolved_rules end)
  end

  def develop_rules(rule_combs, rules) do
    Enum.reduce(rule_combs, [], fn comb, acc ->
      to_process = for rule <- comb, do: Map.get(rules, rule)
      acc ++ combinations(to_process)
    end)
  end

  def combinations([v1]), do: v1

  def combinations([l1, l2]) do
    for e1 <- l1, e2 <- l2, do: e1 <> e2
  end

  def combinations([l1 | rest]) do
    for e1 <- l1, e2 <- combinations(rest), do: e1 <> e2
  end
end
