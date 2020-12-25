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
    |> case do
      [o1, o2] -> [{o1, o2}]
      [o] when is_list(o) -> o
    end
  end

  def task1(file) do
    {rules, msgs} = read(file)
    run(rules, msgs)
  end

  def task2(file) do
    {rules, msgs} = read(file)

    rules =
      rules
      |> Map.put(8, [{[42], [42, 8]}])
      |> Map.put(11, [{[42, 31], [42, 11, 31]}])

    run(rules, msgs)
  end

  def run(rules, msgs) do
    msgs
    |> Enum.map(&{&1, check(&1, Map.get(rules, 0), rules)})
    |> Enum.filter(&(elem(&1, 1) == true))
    |> Enum.count()
  end

  def check(msg, [head | tail], rules) when is_integer(head),
    do: check(msg, Map.get(rules, head) ++ tail, rules)

  def check(msg, [{p1, p2} | tail], rules),
    do: check(msg, p1 ++ tail, rules) or check(msg, p2 ++ tail, rules)

  def check(<<e, rest_msg::binary>>, [<<e>> | tl], rules), do: check(rest_msg, tl, rules)
  def check(<<>>, [], _rules), do: true
  def check(_, _, _), do: false
end
