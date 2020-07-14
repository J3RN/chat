defmodule Chat.Channels.Channel do
  use Chat.Schema
  import Ecto.Changeset

  schema "channels" do
    field :title, :string
    field :archived_at, :utc_datetime_usec

    timestamps()
  end

  @doc false
  def changeset(channels, attrs) do
    channels
    |> cast(attrs, [:title, :archived_at])
    |> validate_required([:title])
  end
end
