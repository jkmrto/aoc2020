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

    Enum.filter(msgs, fn msg -> msg in result end)
    |> Enum.count()
  end

  def run(%{}, %{0 => result}), do: result

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
    if is_resolvable?(rule_combs, Map.keys(resolved_rules)) do
      {rule_id, develop_rules(rule_combs, resolved_rules)}
    else
      retrieve_rule(rest, resolved_rules)
    end
  end

  def is_resolvable?(rule_combs, resolved_rules) do
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

  def combinations([v1]) do
    v1
  end

  def combinations([l1, l2]) do
    for e1 <- l1, e2 <- l2, do: e1 <> e2
  end

  def combinations([l1 | rest]) do
    for e1 <- l1, e2 <- combinations(rest), do: e1 <> e2
  end
end
