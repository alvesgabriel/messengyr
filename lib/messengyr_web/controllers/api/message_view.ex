defmodule MessengyrWeb.MessageView do
  use MessengyrWeb, :view

  def message_json(message, %{me: me}) do
    %{
      id: message.id,
      text: message.text,
      sendAt: message.inserted_at
    }
  end
end
