defmodule ChatWeb.ChannelLive do
  use ChatWeb, :live_view
  alias Chat.{Channels, Result}

  @impl true
  def mount(%{"channel_id" => channel_id}, %{"current_user_id" => current_user_id}, socket) do
    if connected?(socket), do: Channels.subscribe_messages(channel_id)

    messages = Chat.Channels.recent_messages(channel_id)

    socket
    |> assign(:messages, messages)
    |> assign(:channel_id, channel_id)
    |> assign(:user_id, current_user_id)
    |> Result.ok()
  end

  @impl true
  def handle_info({:new, message}, socket) do
    {:noreply, append_message(socket, message)}
  end

  @impl true
  def handle_event("send_message", %{"new_message" => text}, socket) do
    Channels.create_message(socket.assigns.channel_id, socket.assigns.user_id, text)

    {:noreply, socket}
  end

  defp append_message(socket, message) do
    messages = [message | socket.assigns.messages]

    assign(socket, :messages, messages)
  end

  def class(%{user_id: user_id}, user_id), do: "me"
  def class(_message, _user_id), do: "not-me"
end
