defmodule Aoc2020.Day15 do
  @input [16, 12, 1, 0, 15, 7, 11]
  @limit1 2020
  @limit2 30_000_000

  def task1(), do: run(@input, nil, %{}, 1, @limit1)
  def task2(), do: run(@input, nil, %{}, 1, @limit2)

  def run(_start, last, _regs, index, stop) when index > stop, do: last

  def run([h | t], _last, registry, index, stop) do
    run(t, h, Map.put(registry, h, index), index + 1, stop)
  end

  def run([], last, registry, index, stop) do
    value =
      case Map.get(registry, last, :nop) do
        {latest, previous} -> latest - previous
        _latest -> 0
      end

    registry =
      Map.update(registry, value, index, fn
        {latest, _previous} -> {index, latest}
        previous -> {index, previous}
      end)

    run([], value, registry, index + 1, stop)
  end
end
