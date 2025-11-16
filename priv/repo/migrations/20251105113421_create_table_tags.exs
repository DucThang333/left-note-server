defmodule LeftNoteServer.Repo.Migrations.CreateTableTags do
  use Ecto.Migration

  def change do
    create table(:tags, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :object, :text, null: false
      add :object_id, :uuid, null: false
      add :tag_id, :uuid
      add :name, :string, size: 50, null: false
      add :description, :text
      add :created_at, :utc_datetime, default: fragment("now()")
      add :updated_at, :utc_datetime, default: fragment("now()")
      add :is_archived, :boolean, default: false
    end
  end
end
