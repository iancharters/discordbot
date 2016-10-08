defmodule Test do
  def socket do
    token_object = Discordbot.Connect.pass_token

    socket = Discordbot.Connect.get_gateway
              |> Socket.Web.connect!(secure: true)

    socket |> Socket.Web.send({:text, token_object})

    Task.async fn ->
      #Discordbot.Scheduler.handle_recv(socket, %{})
      Discordbot.Scheduler.listen(socket)

    end
  end
end
