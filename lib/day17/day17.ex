defmodule Aoc2020.Day17 do
  @neigborhods for(n <- [-1, 0, 1], m <- [-1, 0, 1], k <- [-1, 0, 1], do: {m, n, k}) --
                 [{0, 0, 0}]

  def read(file) do
    file
    |> File.stream!([], :line)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce([], fn {row, y}, actives ->
      new_actives =
        row
        |> Enum.filter(&(elem(&1, 0) == "#"))
        |> Enum.map(fn {_, x} -> {x, y, 0} end)

      new_actives ++ actives
    end)
  end

  def task1(file) do
    actives = read(file)
    run(actives, 1)
  end

  def count_actives({x, y, z}, actives) do
    Enum.reduce(@neigborhods, 0, fn {x_n, y_n, z_n}, acc ->
      if {x + x_n, y + y_n, z + z_n} in actives, do: acc + 1, else: acc
    end)
  end

  def run(actives, iter) when iter > 6, do: length(actives)

  def run(actives, iter) do
    keep_actives =
      Enum.reduce(actives, [], fn cell, acc ->
        if count_actives(cell, actives) in [2, 3], do: [cell | acc], else: acc
      end)

    actives_neigborhods =
      Enum.reduce(actives, [], fn {x, y, z}, acc ->
        Enum.reduce(@neigborhods, acc, fn
          {x_n, y_n, z_n}, acc -> [{x + x_n, y + y_n, z + z_n} | acc]
        end)
      end)

    actives_neigborhods = actives_neigborhods |> Enum.uniq()

    new_actives =
      Enum.reduce(actives_neigborhods, [], fn cell, acc ->
        if count_actives(cell, actives) == 3, do: [cell | acc], else: acc
      end)

    all_actives = Enum.uniq(keep_actives ++ new_actives)
    run(all_actives, iter + 1)
  end
end
