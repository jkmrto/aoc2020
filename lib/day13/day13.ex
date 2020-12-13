defmodule Aoc2020.Day13 do
  def read(file) do
    file
    |> File.stream!([], :line)
    |> Enum.map(&String.trim/1)
  end

  def task1(file) do
    [line1, line2] = read(file)

    arrive_at = line1 |> Integer.parse() |> elem(0)

    buses =
      line2
      |> String.split(",")
      |> Enum.filter(&(&1 != "x"))
      |> Enum.map(&elem(Integer.parse(&1), 0))

    buses
    |> Enum.map(fn bus -> {bus, (1 + div(arrive_at, bus)) * bus - arrive_at} end)
    |> Enum.sort(&(elem(&1, 1) < elem(&2, 1)))
    |> hd()
    |> (fn {bus, time} -> bus * time end).()
  end

  def task2(file) do
    [_, raw_buses] = read(file)

    raw_buses
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.filter(&(elem(&1, 0) != "x"))
    |> Enum.map(fn {v, i} -> {elem(Integer.parse(v), 0), i} end)
    |> run()
  end

  def run(buses), do: run({0, 1}, buses)
  def run({ts, step}, [head | tail]), do: run(find_min_cross_ts({ts, step}, head), tail)
  def run({ts, _step}, []), do: ts

  def find_min_cross_ts({ts, step}, {bus, index}) do
    cond do
      rem(ts + index, bus) == 0 -> {ts, lcm(step, bus)}
      true -> find_min_cross_ts({ts + step, step}, {bus, index})
    end
  end

  def lcm(a, b), do: div(a * b, Integer.gcd(a, b))
end
