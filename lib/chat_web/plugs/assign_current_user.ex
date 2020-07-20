defmodule ChatWeb.Plug.LiveViewAuth do
  def init(opts), do: opts

  def call(conn, _opts) do
    Plug.Conn.put_session(conn, :current_user_id, conn.assigns.current_user.id)
  end
end
