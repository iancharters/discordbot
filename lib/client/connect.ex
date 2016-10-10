defmodule Discordbot.Connect do
  @discord_gateway "https://discordapp.com/api/gateway?encoding=json&v=5"

  """
  Queries the discord gateway for the websocket gateway address.  Discord
  recommends doing this, I assume to check if the api gateway has changed.
  If it fails it will display a message.
  """

  def start do
    token_object = Discordbot.Connect.pass_token

    socket = Discordbot.Connect.get_gateway
              |> Socket.Web.connect!(secure: true)

    socket
      |> Socket.Web.send({:text, token_object})

      Task.async fn ->
        Discordbot.Scheduler.listen(socket)
      end

    {:ok, socket, token_object}
  end

  def get_gateway do
    case HTTPoison.get(@discord_gateway) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          %{"url" => url} = body |> Poison.decode!
          [ _ | [ res | _ ] ] = url |> String.split("//")
          res

      {:error, %HTTPoison.Error{reason: reason}} ->
        #Something is wrong with the discord API.
        IO.puts IO.ANSI.red <>
                "FAILED TO RETRIEVE DISCORD API GATEWAY ADDRESS" <>
                IO.ANSI.reset
    end
  end

  """
  Creates the JSON structure that makes up the initial idenitifier passed to
  Discord.  Bot token should be set as the environment variable `BOT_TOKEN`.
  """

  def pass_token do
    identity = %{
      "op" => 2,
      "d" => %{
        "v" => 5,
        "token" => System.get_env("BOT_TOKEN"),
        "properties" => %{
          "$os"               => "OSX",
          "$browser"          => "elixir-bot",
          "$device"           => "elixir-bot",
          "$referrer"         => "",
          "$referring_domain" => ""
          },
        "compress" => false,
        "large_threshold" => 250,
        "shard" => [0, 1]
      }
    } |> Poison.encode!
  end
end
