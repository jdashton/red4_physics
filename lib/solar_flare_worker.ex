defmodule SolarFlareWorker do
  def run(spawns) when is_integer(spawns) do
    {:ok, pid} = SolarFlareRecorder.start_link
    Enum.map 1..spawns, fn(n) ->
      SolarFlareRecorder.record(pid, %{index: n, classification: :X, scale: 33})
    end
  end
end
