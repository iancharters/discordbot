defmodule Discordbot.Op do
  def opcodes do
    %{
      :dispatch               => 0,
      :heartbeat              => 1,
      :identify               => 2,
      :status_update          => 3,
      :voice_state_update     => 4,
      :voice_server_ping      => 5,
      :resume                 => 6,
      :reconnect              => 7,
      :request_guild_members  => 8,
      :invalid_session        => 9
    }
  end
end

defmodule Discordbot.Scheduler do
  alias Discordbot.State

  # LISTENER
  def listen(socket), do: listen(socket, %State{session_id: 0})

  def listen(socket, state) do

    if state.session_id == 0, do: msg_connected()
    IO.puts "LISTENING................................"
    # Start recevining
    {:text, data} = Socket.Web.recv!(socket)
    IO.puts "DATA RECEIVED."
    # Check for OP codes and handle
      case Poison.decode!(data) do
        %{"op" => 0, "d" => %{"session_id" => session_id}} ->
          IO.inspect({"SESSION: ", session_id})
          # Start sending heartbeat to Discord server.

          #Discordbot.Heartbeat.start(socket)
          Discordbot.Heartbeat.start(socket)
          # Call itself
          listen(socket, state |> Map.merge(%{session_id: session_id}))
          # Task.async(fn ->
          #   listen(socket, %State{})
          # end)
        %{"op" => 11} ->
          IO.inspect data
          IO.puts "Nothing?"
          listen(socket, state)
        _ ->
          IO.inspect data
          IO.puts "please.."
      end
  end

  defp msg_connected do
    IO.puts IO.ANSI.green <>
            "CONNECTED."
            IO.ANSI.reset
  end
end
