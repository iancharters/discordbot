defmodule Discordbot.Scheduler do
  alias Discordbot.State

  def handle_recv(_, %{done: true}) do
    :ok
  end

  def handle_recv(socket, %{} = state) do
    case socket |> Socket.Web.recv! do
      {:close, _, _} ->
        handle_recv(socket, %{state | done: true})

      {:text, data} ->
        case Poison.decode!(data) do
          %{"op" => 0, "d" => %{
            "session_id" => session_id
          }} ->
            IO.inspect({"WE SESSION NOW BOIS", session_id})
            handle_recv(socket, state |> Map.merge(%{
              session_id: session_id,
            }))
      _ ->
        IO.puts "dead?"
        end

      {:ping, _ } ->
        socket |> Socket.Web.send!({:pong, ""})
        handle_recv(socket, %{state | done: false})
    end
  end

  # LISTENER
  def listen(socket), do: listen(socket, %State{session_id: 0})

  def listen(socket, state) do
    # If this is the first time listen has run...
    # IF NEW SESSION
    #   GRAB / SET HEARTBEAT
    #   CREATE ASYNC HEARTBEAT
    #
    # HEARTBEAT GETS SYNC FROM AN AGENT
    Discordbot.Heartbeat.start()

    # Start recevining
    {:text, data} = Socket.Web.recv!(socket)

    # Check for OP codes and handle
    case Poison.decode!(data) do
      %{"op" => 0, "d" => %{"session_id" => session_id}} ->
        IO.inspect({"SESSION: ", session_id})
        listen(socket, state |> Map.merge(%{session_id: session_id}))
      #%{"op" => }
    end

  end

  # HEARTBEAT
  def send_heartbeat(socket, seq \\ :os.system_time(:milli_seconds)) do
    heartbeat = %{
      "op" => 1,
      "d" => seq
    }
    IO.inspect({"HEARTBEAT:", heartbeat})
    Socket.Web.send!(socket, {:text, Poison.encode!(heartbeat)})
  end
end
