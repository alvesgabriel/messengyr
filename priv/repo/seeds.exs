# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Messengyr.Repo.insert!(%Messengyr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Messengyr.{Chat, Repo, Accounts}
alias Messengyr.Accounts.User

password = "lightside"

# Create a new room
{:ok, room} = Chat.create_room()

yoda = %{
  "username" => "yoda",
  "email" => "yoda@jedi.com",
  "password" => password
}
yoda = case user = Repo.get_by(User, username: yoda["username"]) do
    nil -> Accounts.create_user(yoda) |> elem(1)
    _ -> user
  end

windu = %{
  "username" => "windu",
  "email" => "windu@jedi.com",
  "password" => password
}
windu = case user = Repo.get_by(User, username: windu["username"]) do
    nil -> Accounts.create_user(windu) |> elem(1)
    _ -> user
  end

Chat.add_room_user(room, yoda)
Chat.add_room_user(room, windu)

Chat.add_message(%{
  room: room,
  user: yoda,
  text: "May the force be with you!"
})
