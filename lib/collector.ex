defmodule MailCatchex.Collector do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add(message) do
    Agent.update(__MODULE__, fn messages -> [message | messages] end)
  end

  def fetch do
    Agent.get(__MODULE__, &(&1))
  end
end
