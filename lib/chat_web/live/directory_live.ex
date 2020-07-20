defmodule ChatWeb.DirectoryLive do
  use ChatWeb, :live_view
  alias Chat.{Channels, Result}

  @impl true
  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    if connected?(socket), do: Channels.subscribe_channels()

    channels = Channels.list_channels()

    socket
    |> assign(:channels, channels)
    |> assign(:user_id, current_user_id)
    |> Result.ok()
  end

  @impl true
  def handle_info({:new, channel}, socket) do
    {:noreply, assign(socket, "directory", [channel | socket.assigns.channels])}
  end

  @impl true
  def handle_event("new_channel", %{"channel_name" => channel_name}, socket) do
    Channels.create_channel(channel_name)

    {:noreply, socket}
  end
end
