defmodule Chat.Channels.Membership do
  use Chat.Schema
  import Ecto.Changeset

  schema "memberships" do
    belongs_to :user, Chat.Accounts.User
    belongs_to :channel, Chat.Channels.Channel

    field :disconnected_at, :utc_datetime_usec

    timestamps()
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:user_id, :channel_id, :disconnected_at])
    |> validate_required([:user_id, :channel_id])
  end
end
