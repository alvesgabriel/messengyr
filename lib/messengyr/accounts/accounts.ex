defmodule Messengyr.Accounts do
  import Ecto.Changeset
  alias Messengyr.Repo
  alias Messengyr.Accounts.User

  def create_user(%{"password" => password} = params) do
    encrypted_password = Bcrypt.hash_pwd_salt(password)

    register_changeset(params)
    |> put_change(:encrypted_password, encrypted_password)
    |> Repo.insert()
  end

  def register_changeset(params \\ %{}) do
    %User{}
    |> cast(params, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_format(:email, ~r/@/)
    |> validate_format(:username, ~r/^[\w.]*$/)
    |> validate_length(:password, min: 4)
  end
end
