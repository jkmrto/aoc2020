defmodule Aoc2020.Day17 do
  @neigborhods_3 for(n <- [-1, 0, 1], m <- [-1, 0, 1], k <- [-1, 0, 1], do: {m, n, k}) --
                   [{0, 0, 0}]
  @neigborhods_4 for(
                   n <- [-1, 0, 1],
                   m <- [-1, 0, 1],
                   k <- [-1, 0, 1],
                   l <- [-1, 0, 1],
                   do: {m, n, k, l}
                 ) --
                   [{0, 0, 0, 0}]

  def read(file, mode) do
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
        |> Enum.map(fn {_, x} ->
          case mode do
            :dim_3 -> {x, y, 0}
            :dim_4 -> {x, y, 0, 0}
          end
        end)

      new_actives ++ actives
    end)
  end

  def task1(file) do
    actives = read(file, :dim_3)
    run(actives, 1)
  end

  def task2(file) do
    actives = read(file, :dim_4)
    run(actives, 1)
  end

  def run(actives, iter) when iter > 6, do: length(actives)

  def run(actives, iter) do
    IO.puts("Iter: #{iter}")

    keep_actives =
      Enum.reduce(actives, [], fn cell, acc ->
        if count_actives(cell, actives) in [2, 3], do: [cell | acc], else: acc
      end)

    new_actives =
      actives
      |> get_inactives_neighbours()
      |> Enum.uniq()
      |> Enum.reduce([], fn cell, acc ->
        if count_actives(cell, actives) == 3, do: [cell | acc], else: acc
      end)

    run(Enum.uniq(keep_actives ++ new_actives), iter + 1)
  end

  def count_actives({x, y, z}, actives) do
    Enum.reduce(@neigborhods_3, 0, fn {x_n, y_n, z_n}, acc ->
      if {x + x_n, y + y_n, z + z_n} in actives, do: acc + 1, else: acc
    end)
  end

  def count_actives({x, y, z, w}, actives) do
    Enum.reduce(@neigborhods_4, 0, fn {x_n, y_n, z_n, w_n}, acc ->
      if {x + x_n, y + y_n, z + z_n, w + w_n} in actives, do: acc + 1, else: acc
    end)
  end

  def get_inactives_neighbours(actives = [{_, _, _} | _]) do
    Enum.reduce(actives, [], fn {x, y, z}, acc ->
      Enum.reduce(@neigborhods_3, acc, fn
        {x_n, y_n, z_n}, acc -> [{x + x_n, y + y_n, z + z_n} | acc]
      end)
    end)
  end

  def get_inactives_neighbours(actives = [{_, _, _, _} | _]) do
    Enum.reduce(actives, [], fn {x, y, z, w}, acc ->
      Enum.reduce(@neigborhods_4, acc, fn
        {x_n, y_n, z_n, w_n}, acc -> [{x + x_n, y + y_n, z + z_n, w + w_n} | acc]
      end)
    end)
  end
end
