defmodule Solar.Flare do

  defstruct [
    classification: :M,
    scale: 0,
    power: 0,
    is_deadly: false,
    date: nil
    ]

  def load(flares) do
    for flare <- flares, do: flare |> calculate_power |> calculate_deadliness
  end

  def power(%{classification: :X, scale: s}), do: s * 1000
  def power(%{classification: :M, scale: s}), do: s * 10
  def power(%{classification: :C, scale: s}), do: s * 1

  def calculate_power(flare) do
    factor = case flare.classification do
      :M ->   10
      :X -> 1000
      :C ->    1
    end
    %{flare | power: flare.scale * factor}
  end

  def calculate_deadliness(flare) do
    %{flare | is_deadly: flare.power > 1000}
  end

  def no_eva(flares) do
    Enum.filter flares, fn(flare) ->
      power(flare) > 1000
    end
  end

  def deadliest(flares) do
    Enum.map(flares, &(power(&1)))
      |> Enum.max
  end

  # %{classification: :X, scale: 99, date: Date.from({1859, 8, 29})}
  def sum_1(flares) do
    Enum.map(flares, &(power(&1))) 
      |> Enum.sum
  end

  def sum_1_reduce(flares) do
    Enum.reduce flares, 0, &(power(&1) + &2)
  end

  def sum_2(flares), do: sum_2(flares, 0)
  def sum_2([], total), do: total
  def sum_2([head | tail], total), do: sum_2(tail, power(head) + total)

  def sum_3(flares) do 
    (for flare <- flares, do: power(flare)) 
      |> Enum.sum
  end

  def flare_list(flares) do
    for flare <- flares, 
      power <- [power(flare)],
      is_deadly <- [power > 1000],
      do: %{power: power, is_deadly: is_deadly}
  end

end
