defmodule MailCatchex.ServerCallback do
  @behaviour :gen_smtp_server_session

  require Logger

  def init(hostname, _session_count, address, _options) do
    Logger.metadata(pid: self())
    Logger.debug(fn -> "A connection from #{inspect(address)} to host #{hostname}" end)
    {:ok, "Welcome to Mailex Server", %{from: nil, to: nil, message: nil}}
  end

  def handle_HELO(hostname, state) do
    Logger.debug(fn -> "HELO from #{hostname}" end)
    {:ok, state}
  end

  def handle_EHLO(hostname, exts, state) do
    Logger.debug(fn -> "EHLO from #{hostname} with exts #{inspect(exts)}" end)
    {:ok, exts, state}
  end

  def handle_MAIL(from, state) do
    Logger.debug(fn -> "FROM #{from}" end)
    {:ok, %{state | from: from}}
  end

  def handle_MAIL_extension(ext, _state) do
    Logger.debug(fn -> "Extension: #{ext}" end)
    :error
  end

  def handle_RCPT(to, state) do
    Logger.debug(fn -> "To: #{to}" end)
    {:ok, %{state | to: to}}
  end

  def handle_RCPT_extension(ext, state) do
    Logger.debug(fn -> "RCPT extension: #{ext}" end)
    {:ok, state}
  end

  def handle_DATA(from, to, data, state) do
    Logger.debug(fn -> "data from #{from} to #{to}" end)
    Logger.debug(fn -> "data: #{inspect(data)}" end)
    ref = "#{System.unique_integer()}"
    [headers, body] = String.split(data, "\r\n\r\n", parts: 2, trim: true)
    data = %{state | message: {headers, body}}
    MailCatchex.Collector.add({ref, {data.from, data.to, {headers, body}}})
    {:ok, ref, data}
  end

  def handle_RSET(state) do
    Logger.debug(fn -> "Reset" end)
    state
  end

  def handle_VRFY(address, state) do
    Logger.debug(fn -> "Verify: #{address}" end)
    {:ok, address, state}
  end

  def handle_other(verb, args, state) do
    Logger.debug(fn -> "other #{verb} #{inspect(args)}" end)
    {:ok, state}
  end

  def handle_AUTH(type, user, pass, state) do
    Logger.debug(fn -> "Auth #{type} #{user} #{pass}" end)
    {:ok, state}
  end

  def code_change(_vsn, state, _extra) do
    {:ok, state}
  end

  def terminate(reason, state) do
    {:ok, reason, state}
  end
end
