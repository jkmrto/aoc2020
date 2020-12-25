defmodule Aoc2020.Day19WrongApproach do
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
    result = run(pending_rules, %{}, 0)
    count_valid_msgs(msgs, result)
  end

  def task2(file) do
    {pending_rules, msgs} = read(file)

    max_len =
      msgs
      |> Enum.map(&String.length(&1))
      |> Enum.max()

    pending_rules
    |> set_loop_rules()
    |> run(%{}, max_len)
  end

  def set_loop_rules(pending_rules) do
    rules_changes = [
      {8, [[42], [42, "X"]]},
      {11, [[42, 31], [42, "X", 31]]}
    ]

    Enum.reduce(rules_changes, pending_rules, fn {key, rule}, pending_rules ->
      Map.put(pending_rules, key, rule)
    end)
  end

  def count_valid_msgs(msgs, valid_msgs) do
    msgs
    |> Enum.filter(&(&1 in valid_msgs))
    |> Enum.count()
  end

  def run(%{}, %{0 => result}, _max_len), do: MapSet.new(result)

  def run(pending_rules, resolved_rules, max_len) do
    {rule_id, rule_result} =
      pending_rules
      |> Enum.into([])
      |> retrieve_rule(resolved_rules, max_len)

    run(
      Map.drop(pending_rules, [rule_id]),
      Map.put(resolved_rules, rule_id, rule_result),
      max_len
    )
  end

  def retrieve_rule([{rule_id, [rule_value]} | _rest], _resolved, _max_len)
      when is_binary(rule_value) do
    {rule_id, [rule_value]}
  end

  def retrieve_rule([{rule_id, rule_combs} | rest], resolved_rules, max_len) do
    IO.puts("rule_id: #{inspect(rule_id)}, combs: #{inspect(rule_combs)}, max_len: #{max_len}")
    is_resolvable = is_resolvable?(rule_combs, resolved_rules)
    is_recursive = is_recursive?(rule_combs)

    IO.inspect({is_resolvable, is_recursive}, label: "{is_resolvable, is_recursive}")

    cond do
      is_resolvable && is_recursive ->
        develop_loop_rule(rule_combs, resolved_rules, max_len)

      is_resolvable ->
        {rule_id, develop_rules(rule_combs, resolved_rules)}

      true ->
        retrieve_rule(rest, resolved_rules, max_len)
    end
  end

  def develop_loop_rule(rule_combs, rules, max_len) do
    [base_combination, loop_combs] = rule_combs

    to_process = for rule <- base_combination, do: Map.get(rules, rule)
    base_resolved = combinations(to_process)
    apply_loop_rule(base_resolved, base_resolved, loop_combs, rules, max_len)
  end

  def apply_loop_rule(last_combs, acc_combs, loop_rules, rules_registry, max_len) do
    to_process =
      for rule <- loop_rules do
        case rule do
          "X" -> last_combs |> IO.inspect(label: "last combs")
          _ -> Map.get(rules_registry, rule) |> IO.inspect(label: "combs")
        end
      end

    new_combs = combinations(to_process)
    acc_combs = new_combs ++ acc_combs
    IO.inspect("acc combs #{length(acc_combs)}, length: #{String.length(hd(acc_combs))}")

    apply_loop_rule(new_combs, acc_combs, loop_rules, rules_registry, max_len)
  end

  def is_recursive?(rule_combs) do
    rule_combs
    |> Enum.flat_map(& &1)
    |> Enum.any?(&(&1 == "X"))
  end

  def is_resolvable?(rule_combs, resolved_rules) do
    resolved_rules = Map.keys(resolved_rules)

    rule_combs
    |> Enum.flat_map(& &1)
    |> Enum.filter(&(&1 != "X"))
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
