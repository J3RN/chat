defmodule Chat.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :user_id, references(:users), null: false
      add :channel_id, references(:channels), null: false

      add :disconnected_at, :utc_datetime_usec

      timestamps()
    end
  end
end
