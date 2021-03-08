defmodule MessengyrWeb.MessageView do
  use MessengyrWeb, :view

  def message_json(message, %{me: me}) do
    %{
      id: message.id,
      text: message.text,
      outgoing: outgoing?(message, me),
      sentAt: message.inserted_at
    }
  end

  defp outgoing?(message, me) do
    message.user_id == me.id
  end
end
