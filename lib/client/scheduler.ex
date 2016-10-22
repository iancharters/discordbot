defmodule Discordbot.Scheduler do
  alias Discordbot.Events
  alias Discordbot.State
  alias Discordbot.REST
  alias Discordbot.Connect

  e = Events.event

  # LISTENER
  def listen(socket), do: listen(socket, %State{})

  defp listen(socket, state) do

    initial_connect?(socket, state)

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
                      "id"          => user_id,
                      "username"    => username,
                      },
                      "content"     => content,
                      "channel_id"  => channel_id
                    }
           } ->
            #TAKE INUT
            IO.inspect data
            user_msg(username, content, user_id, channel_id)
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

        %{"t" => "PRESENCE_UPDATE"} ->
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
            "****CONNECTED****\n" <>
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

  defp user_msg(name, msg, user_id, channel_id) do
    case System.get_env("OWNER_ID") do
      id ->
        IO.puts IO.ANSI.red <> "[Owner] " <> IO.ANSI.yellow <> "#{name}: " <> IO.ANSI.reset <> msg
        owner_command?(msg, user_id, channel_id)
      _ ->
        IO.puts IO.ANSI.yellow <> "#{name}: " <> IO.ANSI.reset <> msg
        user_command?(msg, user_id, channel_id)
    end
  end

  defp owner_command?(msg, user_id, channel_id) do
    command = msg |> String.split |> List.first

    case command do
      "!echo" ->
        REST.send_message(msg |> String.replace_leading(command <> " ", ""), channel_id)

      _       ->
      IO.puts msg
    end
  end

  defp user_command?(msg, user_id, channel_id) do
    #System.get_env("OWNER_ID")
  end
end
