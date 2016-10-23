defmodule Discordbot.Voice.Connect do
"""
IDENTIFY OBJECT
{
    "server_id": "41771983423143937",
    "user_id": "104694319306248192",
    "session_id": "my_session_id",
    "token": "my_token"
}

VOICE STATE OBJECT
{
    "channel_id": "157733188964188161",
    "user_id": "80351110224678912",
    "session_id": "90326bd25d71d39b9ef95b299e3872ff",
    "deaf": false,
    "mute": false,
    "self_deaf": false,
    "self_mute": true,
    "suppress": false
}
1) Send VOICE STATE UPDATE payload
2)
"""
  @discord_gateway "https://discordapp.com/api/gateway?encoding=json&v=5"

  """
  Queries the discord gateway for the websocket gateway address.  Discord
  recommends doing this, I assume to check if the api gateway has changed.
  If it fails it will display a message.
  """

  def start(socket, state) do
      # voice_token = voice_state_update(state)
      # |> Socket.Web.send({:text, voice_token})

    # token_object = Discordbot.Voice.Connect.pass_token(state)
    #
    # socket = Discordbot.Connect.get_gateway
    #           |> Socket.Web.connect!(secure: true)
    #
    # socket
    #   |> Socket.Web.send({:text, token_object})

      # Task.async fn ->
      #   Discordbot.Scheduler.listen(socket)
      # end

    #{:ok, socket, token_object}
  end

  @doc """
  Creates the JSON structure that makes up the initial idenitifier passed to
  Discord.  Bot token should be set as the environment variable `BOT_TOKEN`.
  """

  def voice_state_update(state) do
    identity = %{
      "op" => 2,
      "d" => %{
        "channel_id"  => "187436375396712448",
        "user_id"     => state.bot.channel_id,
        "session_id"  => state.bot.session_id,
        "deaf"        => false,
        "mute"        => false,
        "self_deaf"   => false,
        "self_mute"   => true,
        "suppress"    => false
        }
      } |> Poison.encode!
  end

  defp pass_token(state) do
    #stuff
  end
end
