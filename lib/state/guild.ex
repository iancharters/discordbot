defmodule Guild do
  defstruct guilds: %{
        channels: %{
          users: %{
            username: "",
            user_id: ""
          },
          channel_id: 0
        },
        guild_id: 0
  }
end
