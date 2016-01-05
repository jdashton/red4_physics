defmodule Physics.Rocketry do
  import Calcs
  import Physics.Laws

  def escape_velocity(:earth), do: Planets.earth |> escape_velocity
  def escape_velocity(:mars),  do: Planets.mars  |> escape_velocity
  def escape_velocity(:moon),  do: Planets.moon  |> escape_velocity
  def escape_velocity(planet) when is_map(planet) do
    planet
      |> calculate_escape
      |> to_km
      |> to_nearest_tenth
  end

  def orbital_acceleration(height), do: orbital_acceleration(Planets.earth, height)
  def orbital_acceleration(:earth, height), do: orbital_acceleration(Planets.earth, height)
  def orbital_acceleration(:mars,  height), do: orbital_acceleration(Planets.mars,  height)
  def orbital_acceleration(:moon,  height), do: orbital_acceleration(Planets.moon,  height)
  def orbital_acceleration(planet, height) do
    (orbital_speed(planet, height) |> squared) / orbital_radius(planet, height)
  end

  def orbital_term(height), do: orbital_term(Planets.earth, height)
  def orbital_term(:mars,  height), do: orbital_term(Planets.mars,  height)
  def orbital_term(:earth, height), do: orbital_term(Planets.earth, height)
  def orbital_term(:moon,  height), do: orbital_term(Planets.moon,  height)
  def orbital_term(planet, height) do
    4 * (:math.pi |> squared) * (orbital_radius(planet, height) |> cubed) / (newtons_gravitational_constant * planet.mass)
      |> square_root
      |> seconds_to_hours
  end

  def correct_height(hours) do
    newtons_gravitational_constant * Planets.earth.mass * (hours |> hours_to_seconds |> squared) / (4 * (:math.pi |> squared))
      |> cube_root
      |> subtract_planets_radius(Planets.earth)
      |> to_km
  end

  defp subtract_planets_radius(big_r, planet) do
    big_r - planet.radius
  end

  defp orbital_speed(height), do: orbital_speed(Planets.earth, height)
  defp orbital_speed(planet, height) do
    newtons_gravitational_constant * planet.mass / orbital_radius(planet, height)
      |> square_root
  end

  defp orbital_radius(height), do: orbital_radius(Planets.earth, height)
  defp orbital_radius(planet, height) do
    planet.radius + (height |> to_m)
  end

  defp calculate_escape(%{mass: mass, radius: radius}) do
    2 * newtons_gravitational_constant * mass / radius
      |> square_root
  end

end
