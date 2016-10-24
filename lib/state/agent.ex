defmodule Discordbot.State.Agent do
  alias Discordbot.State
  def start_link do
    Agent.start_link(fn -> %State{} end, name: __MODULE__)
  end

  @doc "Sets the state"
  def set(new_state) do
    Agent.update(__MODULE__, fn state ->
      Map.merge(state, new_state)
    end)
  end

  @doc "Gets the state"
  def get do
    Agent.get(__MODULE__, fn state -> state end)
  end

  @doc "Gets the sequence"
  def get_sequence do
    Agent.get(__MODULE__, fn state -> Map.fetch!(state, "sequence") end)
  end
end
