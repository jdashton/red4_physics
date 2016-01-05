defmodule PhysicsTest do
  use ExUnit.Case, async: true
  import Calcs
  import Physics.Rocketry
  doctest Physics

  test "rounding to tenths" do
    assert 3.1 == to_nearest_tenth :math.pi
  end

  test "converting to km" do
    assert 34.567 == to_km 34567
  end

  test "ev of Earth" do
    assert 11.2 == escape_velocity(:earth)
  end

  test "ev of Mars" do
    assert to_nearest_tenth(5.03) == escape_velocity(:mars)
  end

  test "ev of the moon" do
    assert to_nearest_tenth(2.38) == escape_velocity(:moon)
  end

  test "acc of 100km over Earth" do
    assert 9.52 == orbital_acceleration(100) |> Float.round(2)
  end

  test "term of orbit @ 100km" do
    assert 1.4 == orbital_term(100)
  end

  test "sane cube root?" do
    assert 3.0 == cube_root(27)
    assert 4.0 == 64 |> cube_root |> to_nearest_tenth
  end

  test "correct height for 4 hours" do
    assert 6421.7 == correct_height(4) |> to_nearest_tenth
  end

  test "correct height for 1.4 hours" do
    assert 100.0 == correct_height(1.4388858557666) |> to_nearest_tenth
  end

end
