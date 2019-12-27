defmodule MailCatchex.Router do
  @moduledoc false

  @index_template Path.join(:code.priv_dir(:mail_catchex), "templates/index.html.eex")
  @show_template Path.join(:code.priv_dir(:mail_catchex), "templates/show.html.eex")

  use Plug.Router
  require Logger
  require EEx

  plug(Plug.RequestId)
  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/" do
    mails = MailCatchex.Collector.fetch()

    conn
    |> send_resp(200, index_template(mails))
  end

  get "/show/:ref" do

    mail =
      MailCatchex.Collector.fetch()
      |> Enum.find(fn {m_ref, _} -> m_ref === ref end)

    conn
    |> send_resp(200, show_template(mail))
  end

  EEx.function_from_file(:defp, :index_template, @index_template, [:mails])
  EEx.function_from_file(:defp, :show_template, @show_template, [:mail])

  defp nl2br(str) do
    String.replace(str, "\n", "<br>")
  end
end
