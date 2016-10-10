defmodule Fuck do
  def new do
    Agent.start_link(fn -> %{} end)
  end

  def set(pid, new_value) do
    state = Agent.get(pid)
    Agent.update(pid, fn -> Map.merge(state, %{sequence: new_value})
    end)
  end

  def get(pid) do
    Agent.get(pid, fn(n) -> n end)
  end
end
