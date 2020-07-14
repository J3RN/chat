defmodule Chat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :user_id, references(:users), null: false
      add :channel_id, references(:channels), null: false
      add :text, :string, null: false

      add :read_at, :utc_datetime_usec

      timestamps()
    end
  end
end
