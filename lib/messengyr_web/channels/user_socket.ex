defmodule MessengyrWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", MessengyrWeb.RoomChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @impl true
  def connect(%{"token" => jwt}, socket) do
    with {:ok, claims} <- Messengyr.Auth.Guardian.decode_and_verify(jwt),
         {:ok, user} <- Messengyr.Auth.Guardian.resource_from_claims(claims) do
      {:ok, assign(socket, :current_user, user)}
    else
      _ -> :error
    end
  end

  def connect(_params, _socket) do
    :error
  end

  # def connect(_params, socket, _connect_info) do
  #   {:ok, socket}
  # end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     MessengyrWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(_socket), do: nil
end
