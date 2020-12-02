defmodule Aoc2020.Day1 do
  def read(file) do
    file
    |> File.stream!([], :line)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def task1(lista) do
    lista
    |> Enum.map(fn x -> Enum.map(lista, fn y -> {x, y} end) end)
    |> Enum.flat_map(& &1)
    |> Enum.filter(fn {x, y} -> x + y == 2020 end)
    |> hd()
    |> (fn {x, y} -> x * y end).()
  end

  def task2(lista) do
    lista
    |> Enum.map(fn x -> Enum.map(lista, fn y -> Enum.map(lista, fn z -> {x, y, z} end) end) end)
    |> Enum.flat_map(& &1)
    |> Enum.flat_map(& &1)
    |> Enum.filter(fn {x, y, z} -> x + y + z == 2020 end)
    |> hd()
    |> (fn {x, y, z} -> x * y * z end).()
  end
end
