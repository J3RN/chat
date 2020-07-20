defmodule Chat.Channels do
  @moduledoc """
  Everything to do with channels. Messages, membership, etc.
  """

  alias Chat.Channels.{Channel, Message}
  alias Chat.{Repo, Result}

  alias Phoenix.PubSub

  @directory_key "directory"

  import Ecto.Query

  @type channel_id :: integer()
  @type user_id :: integer()

  @type attrs :: map()

  @doc """
  Lists all channels.
  """
  @spec list_channels() :: [%Channel{}]
  def list_channels() do
    Repo.all(Channel)
  end

  @doc """
  Persist and broadcast a new channel.
  """
  @spec create_channel(String.t()) :: Result.persist(%Channel{})
  def create_channel(title) when is_bitstring(title) do
    create_channel(%{title: title})
  end

  @spec create_channel(attrs) :: Result.persist(%Channel{})
  def create_channel(attrs) do
    %Channel{}
    |> Channel.changeset(attrs)
    |> Repo.insert()
    |> broadcast_channel(:new)
  end

  def subscribe_channels() do
    PubSub.subscribe(Chat.PubSub, @directory_key)
  end

  defp broadcast_channel({:error, _reason} = error, _event), do: error
  defp broadcast_channel({:ok, channel}, event) do
    PubSub.broadcast(Chat.PubSub, @directory_key, {event, channel})
  end

  @doc """
  Get the 100 most recent messages.
  """
  @spec recent_messages(channel_id) :: [%Message{}]
  def recent_messages(channel_id) do
    Message
    |> where(channel_id: ^channel_id)
    |> order_by(desc: :inserted_at)
    |> preload(:user)
    |> limit(100)
    |> Repo.all()
  end

  @doc """
  Persist and broadcast a new message.
  """
  @spec create_message(channel_id, user_id, String.t()) :: Result.persist(%Message{})
  def create_message(channel_id, user_id, text) do
    create_message(%{channel_id: channel_id, user_id: user_id, text: text})
  end

  @spec create_message(attrs) :: Result.persist(%Message{})
  def create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> preload()
    |> broadcast_message(:new)
  end

  @doc """
  Subscribe to all message changes in the given channel.
  """
  def subscribe_messages(channel_id) do
    PubSub.subscribe(Chat.PubSub, "channel:#{channel_id}")
  end

  defp broadcast_message({:error, _reason} = error, _event), do: error
  defp broadcast_message({:ok, message}, event) do
    PubSub.broadcast(Chat.PubSub, "channel:#{message.channel_id}", {event, message})

    {:ok, message}
  end

  defp preload({:error, _thing} = error), do: error
  defp preload({:ok, %Message{} = message}), do: {:ok, Repo.preload(message, :user)}
end
