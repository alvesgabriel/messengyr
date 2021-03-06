defmodule MessengyrWeb.LayoutView do
  use MessengyrWeb, :view

  def logged_in?(conn) do
    Guardian.Plug.authenticated?(conn, [])
  end

  defp user_data(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def username(conn) do
    %{username: username} = user_data(conn)
    username
  end

  def avatar(conn) do
    %{email: email} = user_data(conn)

    hash_email =
      :crypto.hash(:md5, email)
      |> Base.encode16()
      |> String.downcase()

    "http://www.gravatar.com/avatar/#{hash_email}"
  end
end
