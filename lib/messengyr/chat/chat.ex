defmodule Messengyr.Chat do
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
    |> Repo.insert( )
  end

  def list_rooms() do
    Repo.all(Room)
    |> Repo.preload(:message)
    |> Repo.preload(:user)
  end
end
