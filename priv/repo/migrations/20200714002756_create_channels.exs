defmodule Chat.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :title, :string, null: false
      add :archived_at, :utc_datetime_usec

      timestamps()
    end
  end
end
