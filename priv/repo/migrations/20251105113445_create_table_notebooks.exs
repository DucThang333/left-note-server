defmodule LeftNoteServer.Repo.Migrations.CreateTableNotebooks do
  use Ecto.Migration

  def change do
    create table(:notebooks, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :user_id, references(:users, type: :uuid, on_delete: :nothing)
      add :notebook_id, :uuid
      add :title, :string, size: 100, null: false
      add :description, :text
      add :created_at, :utc_datetime, default: fragment("now()")
      add :updated_at, :utc_datetime, default: fragment("now()")
      add :is_archived, :boolean, default: false
    end

    create index(:notebooks, [:user_id])
  end
end
