defmodule Aoc2020.Day10 do
  def read(file) do
    file
    |> File.stream!([], :line)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&elem(Integer.parse(&1), 0))
  end

  def load_voltages(file) do
    adapters_voltage =
      file
      |> read()
      |> Enum.sort()

    final_voltage = Enum.max(adapters_voltage) + 3
    [0] ++ adapters_voltage ++ [final_voltage]
  end

  def task1(file) do
    load_voltages(file)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [x, y] -> y - x end)
    |> Enum.frequencies()
    |> (fn %{1 => diff1, 3 => diff3} -> diff1 * diff3 end).()
  end

  def task2(file) do
    voltages = load_voltages(file)

    run(%{0 => 1}, voltages)
    |> Map.get(List.last(voltages))
  end

  def run(comb_registry, [evaluated | others]) do
    comb_registry
    |> check_available_value(evaluated, 1, others)
    |> check_available_value(evaluated, 2, others)
    |> check_available_value(evaluated, 3, others)
    |> run(others)
  end

  def run(comb_registry, []), do: comb_registry

  def check_available_value(comb_registry, current_value, to_add, next_values) do
    comb_current_value = Map.fetch!(comb_registry, current_value)

    cond do
      (current_value + to_add) in next_values ->
        Map.update(
          comb_registry,
          current_value + to_add,
          comb_current_value,
          &(&1 + comb_current_value)
        )

      true ->
        comb_registry
    end
  end
end
