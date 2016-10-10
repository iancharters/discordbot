defmodule Discordbot.Scheduler do
  import Discordbot.Events, only: [:events]
  alias Discordbot.State
  alias Discordbot.Connect


  e = Events.event

  # LISTENER
  def listen(socket), do: listen(socket, %State{session_id: 0})

  def listen(socket, state) do

    if state.session_id == 0, do: msg_connected()

    IO.puts "LISTENING................................"

    {:text, data} = Socket.Web.recv!(socket)

    # Check for OP codes and handle
      case Poison.decode!(data) do
         %{"t" => "READY", "d" => %{"session_id" => session_id}} ->
          Discordbot.Heartbeat.start(socket)
          listen(socket, state |> Map.merge(%{session_id: session_id}))
        %{"op" => 11} ->
          IO.inspect Poison.decode!(data)
          IO.puts "SERVER: HEARTBEAT ACK"
          listen(socket, state)
        _ ->
          IO.inspect Poison.decode!(data)
          IO.puts "UNHANDLED MSG TYPE"
          listen(socket, state)
      end
  end

  defp msg_connected do
    IO.puts IO.ANSI.green <>
            "CONNECTED."
            IO.ANSI.reset
  end
end
