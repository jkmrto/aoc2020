defmodule Aoc2020.Day4 do
  @required_codes ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]

  def read(file) do
    File.stream!(file, [], :line)
    |> Enum.map(&String.trim/1)
  end

  def process_input(raw), do: process_input(raw, [], [])

  def process_input([head | tail], current, acc) do
    case head do
      "" ->
        process_input(tail, [], [current | acc])

      raw ->
        processed_codes =
          raw
          |> String.split(" ")
          |> Enum.map(&(String.split(&1, ":") |> List.to_tuple()))

        process_input(tail, current ++ processed_codes, acc)
    end
  end

  def process_input([], [], acc), do: acc
  def process_input([], current, acc), do: [current | acc]

  def task1(file) do
    read(file)
    |> process_input()
    |> Enum.filter(&contains_required_codes?(&1))
    |> Enum.count()
  end

  def task2(file) do
    read(file)
    |> process_input()
    |> Enum.filter(&contains_required_codes?(&1))
    |> Enum.filter(&Enum.map(&1, fn code -> validate(code) end))
    |> Kernel.length()
  end

  def contains_required_codes?(passport) do
    passport
    |> Enum.map(&elem(&1, 0))
    |> (&(@required_codes -- &1)).()
    |> (&(&1 == [] || &1 == ["cid"])).()
  end

  def validate({"byr", value}), do: elem(Integer.parse(value), 0) in 1920..2002
  def validate({"iyr", value}), do: elem(Integer.parse(value), 0) in 2010..2020
  def validate({"eyr", value}), do: elem(Integer.parse(value), 0) in 2020..2030

  def validate({"hgt", value}) when is_binary(value), do: validate({"hgt", Integer.parse(value)})
  def validate({"hgt", {value, "cm"}}), do: value in 150..193
  def validate({"hgt", {value, "in"}}), do: value in 59..76

  def validate({"hcl", value}), do: String.match?(value, ~r/#[0-9a-f]{6}$/)
  def validate({"ecl", value}), do: value in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  def validate({"pid", value}), do: String.match?(value, ~r/^[0-9]{9}$/)
  def validate({"cid", _}), do: true
  def validate(_), do: false
end
