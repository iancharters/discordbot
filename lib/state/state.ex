defmodule Discordbot.State do
  defstruct bot: %{
        heartbeat_interval: 0,
        session_id: 0,
        user_id: 0,
        sequence: 0,
        email: "",
    },
    gateway: "",
    socket: nil
end
