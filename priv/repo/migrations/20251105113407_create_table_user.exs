defmodule LeftNoteServer.Repo.Migrations.CreateTableUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :username, :string, size: 50, null: false
      add :email, :string, size: 100, null: false
      add :password_hash, :text, null: false
      add :created_at, :utc_datetime, default: fragment("now()")
      add :is_deleted, :boolean, default: false
      add :avatar, :string, size: 255
      add :name, :string, size: 255
      add :updated_at, :utc_datetime
    end
  end
end
