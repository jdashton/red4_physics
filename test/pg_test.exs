defmodule PGTest do
  use ExUnit.Case
  use Timex

  setup do
    flares = [
      %Solar.Flare{classification: :X, scale: 99,   date: Date.from({1859, 8, 29})},
      %Solar.Flare{classification: :M, scale:  5.8, date: Date.from({2015, 1, 12})},
      %Solar.Flare{classification: :M, scale:  1.2, date: Date.from({2015, 2, 9})},
      %Solar.Flare{classification: :C, scale:  3.2, date: Date.from({2015, 4, 18})},
      %Solar.Flare{classification: :M, scale: 83.6, date: Date.from({2015, 6, 23})},
      %Solar.Flare{classification: :C, scale:  2.5, date: Date.from({2015, 7, 4})},
      %Solar.Flare{classification: :X, scale: 72,   date: Date.from({2012, 7, 23})},
      %Solar.Flare{classification: :X, scale: 45,   date: Date.from({2003, 11, 4})},
    ]
    {:ok, data: flares}
  end

  test "Connecting with postgrex", %{data: _flares} do
    {:ok, pid} = Postgrex.Connection.start_link(
      hostname: "localhost", 
      database: "redfour", 
      username: "postgres", 
      password: "postgres"
    )

    # sql = """
    # insert into solar_flares(classification, scale, date)
    # values($1, $2, $3);
    # """

    # res = Enum.map flares, fn(flare) ->
      # ts = %Postgrex.Timestamp{
        # year: flare.date.year, 
        # month: flare.date.month, 
        # day: flare.date.day
        # }
      # Postgrex.Connection.query!(
      # pid, 
      # sql, 
      # [
        # Atom.to_string(flare.classification), 
        # flare.scale, 
        # ts
        # ]
      # )
      # end

    sql = """
    select * from solar_flares
    """

    res = Postgrex.Connection.query!(pid, sql, []) |> transform_result

    IO.inspect res
    Postgrex.Connection.stop(pid)
  end

  def transform_result(result) do
    atomized = for col <- result.columns, do: String.to_atom(col)
    for row <- result.rows do
      tmp = List.zip([atomized, row]) |> Enum.into(%{})
      %{tmp | classification: String.to_atom(tmp.classification)}
    end
  end

end
