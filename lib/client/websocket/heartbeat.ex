defmodule Discordbot.Heartbeat do
  def start(socket, interval, seq \\ nil) do
    heartbeat = %{
      "op" => 1,
      "d" => seq
    }

    Task.async(fn ->
      :timer.sleep(interval)
      Socket.Web.send!(socket, {:text, Poison.encode!(heartbeat)})
      start(socket, interval, :os.system_time(:milli_seconds))
    end)
  end
end
