defmodule Discordbot.Scheduler do
  alias Discordbot.Events
  alias Discordbot.State
  alias Discordbot.Connect

  e = Events.event

  # LISTENER
  def listen(socket), do: listen(socket, %State{})

  defp listen(socket, state) do

    initial_connect?(socket, state)
    IO.inspect state

    {:text, data} = Socket.Web.recv!(socket)

    # Check for OP codes and handle
      case Poison.decode!(data) do
         %{"t" => "READY",
           "d" => %{"session_id" => session_id,
                    "heartbeat_interval" => interval,
                    "user" => %{
                      "id" => user_id,
                      "email" => email
                      },
                    }
           } ->
             IO.inspect Poison.decode!(data)

            Discordbot.Heartbeat.start(socket, interval)
            listen(socket, state |> Map.merge(%{
              bot: %{
                session_id: session_id,
                heartbeat_interval: interval,
                user_id: user_id,
                email: email
              }
            }))

         %{"t" => "MESSAGE_CREATE",
           "d" => %{
                    "author" => %{
                      "id"        => id,
                      "username"  => username,
                      },
                      "content"   => content
                    }
           } ->
            user_msg(username, content)
            listen(socket, state)

        %{"t" => "TYPING_START"} ->
          listen(socket, state)

        %{"t" => "GUILD_CREATE",
          "d" => %{
                    "name" => server_name
                  }
          } ->
            IO.puts "Joined guild: #{server_name}"
            listen(socket, state)


        %{"op" => 11} ->
            IO.inspect Poison.decode!(data)
            IO.puts "SERVER: HEARTBEAT ACK"
            listen(socket, state)


        _ ->
            msg_unhandled_case(data)
            listen(socket, state)
      end
  end

  defp initial_connect?(socket, state) do
    if state.bot.session_id == 0, do: msg_connected()
    socket
  end

  defp msg_connected do
    IO.puts IO.ANSI.green <>
            "*****************\n" <>
            "****CONNECTED****\n" <>
            "*****************\n" <>
            IO.ANSI.reset
  end

  def msg_unhandled_case(data) do
    IO.puts   IO.ANSI.red <>
              "*******************************UNHANDLED MSG TYPE*******************************" <>
              IO.ANSI.cyan

    IO.inspect Poison.decode!(data)

    IO.puts   IO.ANSI.red <>
              "********************************************************************************" <>
              IO.ANSI.reset
  end

  defp user_msg(name, msg) do
    IO.puts IO.ANSI.yellow <> "#{name}: " <> IO.ANSI.reset <> msg
  end
end
