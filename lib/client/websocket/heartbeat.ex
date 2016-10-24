defmodule Discordbot.Heartbeat do
  def start(socket, interval, seq \\ nil) do
    state = Discordbot.State.Agent.get
    heartbeat = %{
      "op" => 1,
      "d" => state.sequence
    }

    Task.async(fn ->
      :timer.sleep(interval)
      Socket.Web.send!(socket, {:text, Poison.encode!(heartbeat)})
      start(socket, interval, seq)
    end)
  end
end
