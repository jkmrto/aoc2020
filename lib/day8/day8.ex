defmodule Aoc2020.Day8 do
  def read(file) do
    File.stream!(file, [])
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [op, raw_arg] ->
      {op, Integer.parse(raw_arg) |> elem(0)}
    end)
    |> Enum.with_index()
    |> Enum.map(fn {x, y} -> {y, x} end)
    |> Enum.into(%{})
  end

  def task1(file) do
    run(0, read(file), 0)
  end

  def run(pos, program, acc) do
    op_arg = Map.get(program, pos)
    program = Map.put(program, pos, "visited")

    case op_arg do
      {"nop", _arg} -> run(pos + 1, program, acc)
      {"acc", arg} -> run(pos + 1, program, acc + arg)
      {"jmp", arg} -> run(pos + arg, program, acc)
      "visited" -> {:nop, acc}
      _ -> {:success, acc}
    end
  end

  def task2(file) do
    program = read(file)

    Enum.map(program, fn {index, {op, arg}} ->
      case op do
        "nop" -> run(0, Map.put(program, index, {"jmp", arg}), 0)
        "jmp" -> run(0, Map.put(program, index, {"nop", arg}), 0)
        _ -> {:nop, 0}
      end
    end)
    |> Enum.find(fn {is_success, _} -> is_success == :success end)
  end
end
