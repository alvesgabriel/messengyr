defmodule MessengyrWeb.PageController do
  use MessengyrWeb, :controller

  alias Messengyr.Accounts
  alias Messengyr.Accounts.Session
  alias Messengyr.Auth.Guardian

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    IO.inspect(user)

    render(conn)
  end

  def signup(conn, _params) do
    changeset = Accounts.register_changeset()

    render(conn, user_changeset: changeset)
  end

  def create_user(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfuly!")
        |> redirect(to: "/")

      {:error, user_changeset} ->
        conn
        |> put_flash(:error, "Unable to create account!")
        |> render("signup.html", user_changeset: user_changeset)
    end
  end

  def login(conn, _params) do
    render(conn)
  end

  def login_user(conn, %{"credentials" => credentials}) do
    case Session.authenticated(credentials) do
      {:ok, %{username: username} = user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Logged in as #{username}!")
        |> render("login.html")

      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> render("login.html")
    end
  end
end
