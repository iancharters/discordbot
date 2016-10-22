defmodule Discordbot.REST do
  def message(content, channel) do
    #post_body           = %{"events" => shows} |> Poison.encode!
    url                 = "https://discordapp.com/api/channels/#{channel}/messages"
    #body           = %{"content" => content |> Poison.encode!}
    body            = "hi2u"
    headers        = %{"Content-Type" => "application/json",
                        "Authorization" => "Bot #{System.get_env("BOT_TOKEN")}",
                      }
    {:ok, response}     = HTTPoison.get(url, body, headers)
    #%{status_code: 201} = response
    IO.inspect response
  end

  def send_message(content, channel) do
    #CPDS Text - 194299038558978048
    method = "post"
    key = "Bot #{System.get_env("BOT_TOKEN")}"
    url = <<"https://discordapp.com/api/channels/#{channel}/messages">>
    headers = [ {<<"Content-Type">>, <<"application/json">>},
                {<<"Authorization">>, key} ]

    options = []
    payload = %{"content" => content} |> Poison.encode!
    {:ok, statusCode, respHeaders, clientRef} = :hackney.request(method, url,
                                                            headers, payload,
                                                            options)
  end

end
