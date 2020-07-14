defmodule Chat.Channels.Message do
  use Chat.Schema
  import Ecto.Changeset

  schema "messages" do
    belongs_to :user, Chat.Accounts.User
    belongs_to :channel, Chat.Channels.Channel

    field(:text, :string)

    field(:read_at, :utc_datetime_usec)

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user_id, :channel_id, :text])
    |> validate_required([:user_id, :channel_id, :text])
  end
end
