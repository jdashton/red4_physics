defmodule OTPTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = Postgrex.Connection.start_link(
      hostname: "localhost",
      database: "redfour",
      username: "postgres",
      password: "postgres"
    )
    Postgrex.Connection.query!(pid, "delete from solar_flares;", [])
    Postgrex.Connection.stop(pid)
  end

  test "A simple spawn" do
    res = for _ <- 1..5, do: spawn(fn() -> IO.inspect "HI" end)
    IO.inspect res
  end

  test "A Simple service" do
    {:ok, pid} = SolarFlareRecorder.start_link
    SolarFlareRecorder.record(pid, %{classification: :M, scale: 22, index: 17})
    SolarFlareRecorder.record(pid, %{classification: :X, scale: 33, index: 38})
    res = SolarFlareRecorder.current(pid)
    IO.inspect res
  end

  # It seems like my postgres is set to max 100 connections, some of which
  # may get used by RubyMine or other apps.
  # 99 is the highest number that has ever succeeded here. 50 is probably safe.
  @num_inserts_1 50  
  test "Inserting #{@num_inserts_1} flares asynchronously" do
    _res = Enum.map 1..@num_inserts_1, fn(n) ->
      {:ok, pid} = SolarFlareRecorder.start_link
      SolarFlareRecorder.record(pid, %{index: n, classification: :X, scale: 33})
    end
    :timer.sleep(1000)
    assert Helpers.check_flare_count == @num_inserts_1
  end

  test "Using worker to run 10 recorders concurrently" do
    _res = Enum.map 1..10, fn(_) ->
      spawn(SolarFlareWorker, :run, [10])
    end
    :timer.sleep(1000)
  end

  test "Waiting for recorder with 1000 rows and 10 workers" do
    _res = Enum.map 1..5, fn(_n) ->
      spawn(SolarFlareWorker, :run, [100])
    end
    :timer.sleep(1000)
    IO.inspect Helpers.check_flare_count
  end

end
