defmodule Aoc2020.Day7 do
  def read(file) do
    File.stream!(file, [])
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn line ->
      [out_bag | raw_inside_bags] = Regex.split(~r/ bags?( contain )?(, )?\.?/, line, trim: true)

      case raw_inside_bags do
        ["no other"] ->
          {out_bag, "no other"}

        raw_inside_bags ->
          Enum.map(raw_inside_bags, fn raw_bag ->
            raw_bag
            |> Integer.parse()
            |> (fn {n, type} -> {String.trim(type), n} end).()
          end)
          |> Enum.into(%{})
          |> (fn inside_bags -> {out_bag, inside_bags} end).()
      end
    end)
    |> Enum.into(%{})
  end

  def task1(file) do
    relations = Aoc2020.Day7.read(file)

    Enum.map(Map.to_list(relations), fn {main_bag, _} ->
      if main_bag == "shiny gold", do: false, else: contain_shiny_bag(main_bag, relations)
    end)
    |> Enum.filter(& &1)
    |> Kernel.length()
  end

  def contain_shiny_bag("shiny gold", _relations), do: true

  def contain_shiny_bag(bag, relations) do
    case Map.get(relations, bag) do
      "no other" ->
        false

      inside_bags ->
        Enum.reduce_while(inside_bags, 0, fn {bag, _amount}, _acc ->
          if contain_shiny_bag(bag, relations), do: {:halt, true}, else: {:cont, false}
        end)
    end
  end

  def task2(file) do
    relations = Aoc2020.Day7.read(file)
    bags_counter("shiny gold", relations)
  end

  def bags_counter(bag, relations) do
    case Map.get(relations, bag) do
      "no other" ->
        0

      inside_bags ->
        Enum.reduce(inside_bags, 0, fn {bag, amount}, acc ->
          acc + amount * (1 + bags_counter(bag, relations))
        end)
    end
  end
end
