defmodule LeftNoteServer.Repo.Migrations.CreateTableNote do
  use Ecto.Migration

  def change do
    create table(:notes, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :notebook_id, :uuid
      add :content, :text
      add :title, :string, size: 100, null: false
      add :description, :text
      add :is_archived, :boolean, default: false
      add :created_at, :utc_datetime, default: fragment("now()")
      add :updated_at, :utc_datetime, default: fragment("now()")
    end

    create index(:notes, [:notebook_id])
  end
end
