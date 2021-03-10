defmodule Messengyr.Chat do
  import Ecto.Query

  alias Messengyr.Chat.{Message, Room, RoomUser}
  alias Messengyr.Repo
  alias Messengyr.Accounts.User

  def get_room(id) do
    Repo.get(Room, id)
  end

  def create_room() do
    %Room{} |> Repo.insert()
  end

  def add_room_user(room, user) do
    %RoomUser{
      room: room,
      user: user
    }
    |> Repo.insert()
  end

  def preload_room_data(room) do
    room
    |> Repo.preload(:messages)
    |> Repo.preload(:users)
  end

  defp add_room_users(room, []) do
    {:ok, room |> preload_room_data}
  end

  defp add_room_users(room, [first_user | other_users]) do
    case add_room_user(room, first_user) do
      {:ok, _} ->
        add_room_users(room, other_users)

      _ ->
        {:error, "Failed to add user to room!"}
    end
  end

  def add_message(%{room: room, user: user, text: text}) do
    %Message{
      room: room,
      user: user,
      text: text
    }
    |> Repo.insert()
  end

  def list_rooms() do
    Repo.all(Room)
    |> preload_room_data()
  end

  def list_user_rooms(user) do
    query =
      from r in Room,
        join: u in assoc(r, :users),
        where: u.id == ^user.id

    Repo.all(query)
    |> preload_room_data()
  end

  def create_room_with_counterpart(me, counterpart_username) do
    counterpart = Repo.get_by!(User, username: counterpart_username)
    members = [me, counterpart]

    with {:ok, room} <- create_room() do
      add_room_users(room, members)
    end
  end

  def room_has_user?(room, user) do
    query =
      from ru in RoomUser,
        where: ru.room_id == ^room.id and ru.user_id == ^user.id

    case Repo.one(query) do
      %RoomUser{} -> true
      _ -> false
    end
  end
end
