defmodule MailCatchex.Supervisor do
  use Supervisor

  def start_link(init_arg \\ []) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(args) do
    smtp_port = Keyword.get(args, :smtp_port, 2525)
    http_port = Keyword.get(args, :http_port, 2526)

    children = [
      %{id: MailCatchex.Collector, start: {MailCatchex.Collector, :start_link, []}},
      %{id: MailCatchex.ServerCallback, start: {:gen_smtp_server, :start_link, [MailCatchex.ServerCallback, [[port: smtp_port]]]}},
      Plug.Cowboy.child_spec(scheme: :http, plug: MailCatchex.Router, options: [port: http_port]),
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
