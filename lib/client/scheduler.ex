defmodule Discordbot.Scheduler do
  alias Discordbot.Events
  alias Discordbot.State
  alias Discordbot.REST
  alias Discordbot.Connect

  e = Events.event

  # LISTENER
  def listen(socket), do: listen(socket, %State{socket: socket})

  defp listen(socket, state) do

    initial_connect?(socket, state)

    {:text, data} = Socket.Web.recv!(socket)
    payload = Poison.decode!(data)

    {_, sequence} = Map.fetch(payload, "s")
    state = Map.merge(state, %{sequence: sequence})

    # Check for OP codes and handle
      case payload do
         %{"t" => "READY", "s" => s,
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

            IO.inspect data #TEMP
            user_msg(username, content, user_id, channel_id, state)
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

  defp user_msg(name, msg, user_id, channel_id, state) do
    case System.get_env("OWNER_ID") do
      id ->
        IO.puts IO.ANSI.red <> "[Owner] " <> IO.ANSI.yellow <> "#{name}: " <> IO.ANSI.reset <> msg
        owner_command?(msg, user_id, channel_id, state)
      151948529995087872 ->
        IO.puts IO.ANSI.red <> "[Owner] " <> IO.ANSI.yellow <> "#{name}: " <> IO.ANSI.reset <> msg
        owner_command?(msg, user_id, channel_id, state)
      _ ->
        IO.puts IO.ANSI.yellow <> "#{name}: " <> IO.ANSI.reset <> msg
        user_command?(msg, user_id, channel_id)
    end
  end

  defp owner_command?(msg, user_id, channel_id, state) do
    command = msg |> String.split |> List.first

    case command do
      "!echo"       ->
        REST.send_message(msg |> String.replace_leading(command <> " ", ""), channel_id)
      "!info"       ->
        REST.send_message("SESSION ID: #{state.bot.session_id}", channel_id)
        REST.send_message("BOT USER ID: #{state.bot.user_id}", channel_id)
      "!voice"      ->
        Socket.Web.send(state.socket, {:text, voice_state_update(state)})
      "!sandstorm"  ->
        REST.send_message("dooo do doo doo do doo dooo dooo doo doo do doo dooo dood odod odooo", channel_id)
      "!sequence"      ->
        REST.send_message(state.sequence, channel_id)
      _       ->
      IO.puts msg
    end
  end

  defp user_command?(msg, user_id, channel_id) do
    command = msg |> String.split |> List.first
  case command do
    "!sandstorm" ->
      REST.send_message("dooo do doo doo do doo dooo dooo doo doo do doo dooo dood odod odooo", channel_id)
    end
  end

  def voice_state_update(state) do
    identity = %{
      "op"  => 4,
      "d"   => %{
        "channel_id"  => "187436375396712448",
        "user_id"     => state.bot.user_id,
        "session_id"  => state.bot.session_id,
        "self_deaf"   => false,
        "self_mute"   => true,
        }
      } |> Poison.encode!
  end
end
