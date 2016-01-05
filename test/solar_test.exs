defmodule SolarTest do
  use ExUnit.Case, async: true
  use Timex
  import Solar.Flare

  setup_all do
    flares = [
      %Solar.Flare{classification: :X, scale:   99, date: Date.from({1859,  8, 29})},
      %Solar.Flare{classification: :M, scale:  5.8, date: Date.from({2015,  1, 12})},
      %Solar.Flare{classification: :M, scale:  1.2, date: Date.from({2015,  2,  9})},
      %Solar.Flare{classification: :C, scale:  3.2, date: Date.from({2015,  4, 18})},
      %Solar.Flare{classification: :M, scale: 83.6, date: Date.from({2015,  6, 23})},
      %Solar.Flare{classification: :C, scale:  2.5, date: Date.from({2015,  7,  4})},
      %Solar.Flare{classification: :X, scale:   72, date: Date.from({2012,  7, 23})},
      %Solar.Flare{classification: :X, scale:   45, date: Date.from({2003, 11,  4})},
    ]
    {:ok, data: flares}
  end

  test "We have 8 solar flares", %{data: flares} do
    assert length(flares) == 8
  end

  test "Verify powers", %{data: flares} do
    assert 99000 == flares |> Enum.at(0) |> power
    assert    58 == flares |> Enum.at(1) |> power
    assert    12 == flares |> Enum.at(2) |> power
    assert   3.2 == flares |> Enum.at(3) |> power
    assert   836 == flares |> Enum.at(4) |> power
    assert   2.5 == flares |> Enum.at(5) |> power
    assert 72000 == flares |> Enum.at(6) |> power
    assert 45000 == flares |> Enum.at(7) |> power
  end

  test "Go inside", %{data: flares} do
    d = no_eva(flares)
    assert length(d) == 3
  end

  test "deadliest was 99,000", %{data: flares} do
    assert 99000 == deadliest(flares)
  end

  test "sum of flares 1", %{data: flares} do
    assert 216_911.7 == sum_1(flares)
  end

  test "sum of flares 1 reduce", %{data: flares} do
    assert 216_911.7 == sum_1_reduce(flares)
  end

  test "sum of flares 2", %{data: flares} do
    assert 216_911.7 == sum_2(flares)
  end

  test "sum of flares 3", %{data: flares} do
    assert 216_911.7 == sum_3(flares)
  end

  test "list of deadly flares", %{data: flares} do
    assert flare_list(flares) ==
      [%{is_deadly: true, power: 99000}, %{is_deadly: false, power: 58.0},
       %{is_deadly: false, power: 12.0}, %{is_deadly: false, power: 3.2},
       %{is_deadly: false, power: 836.0}, %{is_deadly: false, power: 2.5},
       %{is_deadly: true, power: 72000}, %{is_deadly: true, power: 45000}]
  end

  test "A Solar Flare is a Map with a special key" do
    assert %Solar.Flare{}.__struct__ == Solar.Flare
  end

  test "flare list comes back with power and is_deadly", %{data: flares} do
    loaded_flares = flares |> load
    biggest_flare = loaded_flares |> Enum.at(0)
    assert 99000 == biggest_flare.power
    assert true == biggest_flare.is_deadly
  end

end
