defmodule SolarFlareRecorder do
  use GenServer
  require Logger

  #API
  def start_link do
    {:ok, pg_pid} = connect #create a connection
    GenServer.start_link(__MODULE__, %{pg_pid: pg_pid})
  end

  def record(pid, flare) do
    # Logger.info "#{__MODULE__}.record called with pid #{inspect pid}"
    GenServer.cast(pid, {:new, flare})
  end

  #Server
  def handle_call(:load, _from, state) do
    {:reply, state, state}
  end

  defp add_flare(args, state) do
    # Logger.info "#{__MODULE__}.add_flare called with state #{inspect state}"
    """
    insert into solar_flares(index, classification, scale, date)
    values($1, $2, $3, now()) RETURNING *;
    """
    |> execute(state, [args.index, Atom.to_string(args.classification), args.scale])
  end

  defp execute(sql, state, params \\ []) do
    # Logger.info "#{__MODULE__}.execute called with state #{inspect state}"
    Postgrex.Connection.query!(state.pg_pid, sql, params) |> transform_result
  end

  def terminate(reason, []) do
    # Logger.info "#{__MODULE__}.terminate called for reason #{inspect reason} with empty state"
  end
  def terminate(reason, state) do
    # Logger.info "#{__MODULE__}.terminate called for reason #{inspect reason}"
    Postgrex.Connection.stop(state.pg_pid) #release on termination
  end

  # These were not given in the last partial code listing
  def current(pid) do
    GenServer.call(pid, :load)
  end

  def handle_cast({:new, flare}, state) do
    # Logger.info "#{__MODULE__}.handle_cast called with state #{inspect state}"
    add_flare(flare, state)
    {:noreply, state}
  end

  #  defp get_flares do
  #    """
  #    select * from solar_flares;
  #    """
  #    |> execute
  #  end

  defp connect do
    Postgrex.Connection.start_link(
      hostname: "localhost",
      database: "redfour",
      username: "postgres",
      password: "postgres"
    )
  end

  defp transform_result(result) do
    atomized = for col <- result.columns, do: String.to_atom(col)
    for row <- result.rows, do: List.zip([atomized, row]) |> Enum.into(%{})
  end

end
