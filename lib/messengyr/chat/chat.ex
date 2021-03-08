defmodule Messengyr.Chat do
  import Ecto.Query

  alias Messengyr.Chat.{Message, Room, RoomUser}
  alias Messengyr.Repo

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
    |> Repo.preload(:messages)
    |> Repo.preload(:users)
  end

  def list_user_rooms(user) do
    query =
      from r in Room,
        join: u in assoc(r, :users),
        where: u.id == ^user.id

    Repo.all(query)
    |> Repo.preload(:messages)
    |> Repo.preload(:users)
  end
end
