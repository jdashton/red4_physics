ExUnit.start()

defmodule Helpers do
  def check_flare_count do
    {:ok, pid} = Postgrex.Connection.start_link(
      hostname: "localhost",
      database: "redfour",
      username: "postgres",
      password: "postgres"
    )
    res = Postgrex.Connection.query!(pid, "select count(1) from solar_flares;", [])
    Postgrex.Connection.stop(pid)
    [[count] | _rest] = res.rows
    count
  end
end
