defmodule Discordbot.Heartbeat.Agent do
  def new do
    Agent.start_link(fn -> %Discordbot.State{} end)
  end

  def set(pid, new_value) do
    Agent.get(pid)
    Agent.update(pid, fn(_n) -> Map.merge
    end)
  end

  def get(pid) do
    Agent.get(pid, fn(n) -> n end)
  end
end

defmodule Discordbot.Heartbeat do
  def start(socket, seq \\ nil) do
    #:os.system_time(:milli_seconds)
    heartbeat = %{
      "op" => 1,
      "d" => seq
    }

    Task.async(fn ->
      :timer.sleep(41250)
      Socket.Web.send!(socket, {:text, Poison.encode!(heartbeat)})
      IO.puts "Heartbeat."
      start(socket, seq)
    end)
  end

  def manual(socket) do
    heartbeat = %{
      "op" => 1,
      "d" => nil
    }

    Socket.Web.send!(socket, {:text, Poison.encode!(heartbeat)})
    Socket.Web.recv!(socket)
    :timer.sleep(41250)
  end
end
