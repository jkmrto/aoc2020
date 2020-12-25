defmodule Aoc2020.Day21 do
  def read(file) do
    File.stream!(file, [], :line)
    |> Enum.map(fn line ->
      {ingredients, allergenes} =
        line
        |> String.replace([",", "(", ")"], "")
        |> String.split("contains")
        |> Enum.map(&String.trim(&1))
        |> Enum.map(&String.split(&1))
        |> (&List.to_tuple(&1)).()

      {MapSet.new(ingredients), allergenes}
    end)
  end

  def get_all_allergenes(foods), do: Enum.flat_map(foods, &elem(&1, 1)) |> Enum.uniq()

  def get_foods_with_allergene(allergene, foods, acc \\ [])

  def get_foods_with_allergene(_allergene, [], acc), do: acc

  def get_foods_with_allergene(allergene, [{ingredients, allergenes} | tail], acc) do
    cond do
      allergene in allergenes -> get_foods_with_allergene(allergene, tail, [ingredients | acc])
      true -> get_foods_with_allergene(allergene, tail, acc)
    end
  end

  def get_common_ingredients(foods_ingredients) do
    foods_ingredients
    |> Enum.map(&MapSet.new(&1))
    |> Enum.reduce(&MapSet.intersection(&1, &2))
  end

  def task1(file) do
    foods = read(file)
    allergenes = get_all_allergenes(foods)
    allergene_ingredients = run(allergenes, foods)

    Enum.reduce(foods, 0, fn {ingredients, _allergenes}, acc ->
      acc + MapSet.size(MapSet.difference(ingredients, allergene_ingredients))
    end)
  end

  def run([allergene | tail], foods, {pending_allergenes, matched_ingredients} \\ {[], []}) do
    common_ingredients =
      allergene
      |> get_foods_with_allergene(foods)
      |> get_common_ingredients()
      |> MapSet.difference(MapSet.new(matched_ingredients))
      |> MapSet.to_list()
      |> case do
        [ingredient] -> run(tail, foods, {pending_allergenes, [ingredient | matched_ingredients]})
        _ -> run(tail, foods, {[allergene | pending_allergenes], matched_ingredients})
      end
  end

  def run([], _foods, {[], match_ingredients}), do: MapSet.new(match_ingredients)

  def run([], _foods, {pending_allergenes, match_ingredients}) do
    run(pending_allergenes, _foods, {[], match_ingredients})
  end
end
