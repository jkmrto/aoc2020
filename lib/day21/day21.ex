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

    ingredients_with_allergene =
      foods
      |> get_all_allergenes()
      |> run(foods)
      |> Enum.map(&elem(&1, 1))
      |> MapSet.new()

    Enum.reduce(foods, 0, fn {ingredients, _allergenes}, acc ->
      acc + MapSet.size(MapSet.difference(ingredients, ingredients_with_allergene))
    end)
  end

  def task2(file) do
    foods = read(file)

    foods
    |> get_all_allergenes()
    |> run(foods)
    |> Enum.sort(&(elem(&1, 0) <= elem(&2, 0)))
    |> Enum.map(&elem(&1, 1))
    |> Enum.join(",")
  end

  def run(allergenes, foods, acc \\ {[], []})

  def run([allergene | tail], foods, {pending_allergenes, allergenes_ingredients}) do
    already_matched_ingredients = allergenes_ingredients |> Enum.map(&elem(&1, 1)) |> MapSet.new()

    allergene
    |> get_foods_with_allergene(foods)
    |> get_common_ingredients()
    |> MapSet.difference(already_matched_ingredients)
    |> MapSet.to_list()
    |> case do
      [ingredient] ->
        run(tail, foods, {pending_allergenes, [{allergene, ingredient} | allergenes_ingredients]})

      _ ->
        run(tail, foods, {[allergene | pending_allergenes], allergenes_ingredients})
    end
  end

  def run([], _foods, {[], allergenes_ingredients}), do: allergenes_ingredients

  def run([], foods, {pending_allergenes, allergenes_ingredients}) do
    run(pending_allergenes, foods, {[], allergenes_ingredients})
  end
end
