defmodule Discordbot.Heartbeat do
  def start do
    Task.async(fn ->
      IO.puts "BEEP. BOOP.  FUCK THE RED TEAM."
      :timer.sleep(5000)
      start()
    end)
  end
end
