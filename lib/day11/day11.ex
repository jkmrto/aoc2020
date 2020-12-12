defmodule Aoc2020.Day11 do
  def read(file) do
    file
    |> File.stream!([], :line)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn row ->
      row
      |> String.graphemes()
      |> list_to_indexed_map()
    end)
    |> list_to_indexed_map()
  end

  def list_to_indexed_map(list) do
    list
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {index, value} end)
    |> Enum.into(%{})
  end

  def task1(file) do
    file
    |> read()
    |> (&run(&1, get_fields_limit(&1), :next_seats)).()
  end

  def task2(file) do
    file
    |> read()
    |> (&run(&1, get_fields_limit(&1), :first_sight_seats)).()
  end

  def run(field, field_limits, mode) do
    case run_step(field, field_limits, mode) do
      ^field -> count_occupied_seats(field)
      differnet_field -> run(differnet_field, field_limits, mode)
    end
  end

  def get_fields_limit(field) do
    n_rows = field |> Enum.to_list() |> Kernel.length()
    n_cols = field |> Enum.to_list() |> hd |> elem(1) |> Enum.to_list() |> Kernel.length()
    {n_rows, n_cols}
  end

  def count_occupied_seats(field) do
    Enum.reduce(field, 0, fn {_, row}, acc ->
      acc +
        Enum.reduce(row, 0, fn {_, value}, acc ->
          if value == "#", do: acc + 1, else: acc
        end)
    end)
  end

  def run_step(field, limits, mode) do
    Enum.reduce(field, %{}, fn {row_index, row}, acc ->
      new_row =
        Enum.reduce(row, %{}, fn {col_index, value}, acc ->
          new_state = get_new_state(value, field, {row_index, col_index}, limits, mode)
          Map.put(acc, col_index, new_state)
        end)

      Map.put(acc, row_index, new_row)
    end)
  end

  def get_new_state(".", _field, _, _, _), do: "."

  def get_new_state(status, field, {row, col}, limits, mode) do
    around_seats_directions = for(x <- [-1, 0, 1], y <- [-1, 0, 1], do: {x, y}) -- [{0, 0}]

    around_seats =
      Enum.map(around_seats_directions, fn dirs = {var_row, var_col} ->
        case mode do
          :next_seats -> check_position(field, {row + var_row, col + var_col}, limits)
          :first_sight_seats -> check_direction(field, {row, col}, dirs, limits)
        end
      end)
      |> Enum.frequencies()

    free_seats_around = Map.get(around_seats, "L", 0) + Map.get(around_seats, ".", 0)
    occupied_seats_around = Map.get(around_seats, "#", 0)

    occupied_seats_threshold =
      case mode do
        :next_seats -> 4
        :first_sight_seats -> 5
      end

    output =
      cond do
        status == "L" && free_seats_around == 8 -> "#"
        status == "#" && occupied_seats_around >= occupied_seats_threshold -> "L"
        true -> status
      end

    output
  end

  def check_direction(field, {row, col}, dir = {dir_row, dir_col}, limits = {n_rows, n_cols}) do
    {new_row, new_col} = {row + dir_row, col + dir_col}

    cond do
      new_col < 0 || new_row < 0 || new_col >= n_cols || new_row >= n_rows ->
        "L"

      true ->
        case field |> Map.fetch!(new_row) |> Map.fetch!(new_col) do
          "L" -> "L"
          "#" -> "#"
          "." -> check_direction(field, {new_row, new_col}, dir, limits)
        end
    end
  end

  def check_position(field, {row, col}, {n_rows, n_cols}) do
    cond do
      col < 0 -> "L"
      row < 0 -> "L"
      col >= n_cols -> "L"
      row >= n_rows -> "L"
      true -> field |> Map.fetch!(row) |> Map.fetch!(col)
    end
  end

  def print(field) do
    Enum.each(field, fn {_, row} ->
      Enum.each(row, fn {_, pos} -> IO.write(pos) end)
      IO.puts("")
    end)
  end
end
