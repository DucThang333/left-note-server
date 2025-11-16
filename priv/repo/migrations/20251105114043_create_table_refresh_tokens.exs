defmodule LeftNoteServer.Repo.Migrations.CreateTableRefreshTokens do
  use Ecto.Migration

  def change do
    create table(:refresh_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")

      # reference to user
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false

      # actual refresh token (you should store it hashed)
      add :token_hash, :text, null: false

      # expiration date for the token
      add :expires_at, :utc_datetime, null: false

      # revoked = user logged out or token invalid
      add :revoked, :boolean, default: false

      # standard audit fields
      add :created_at, :utc_datetime, default: fragment("now()")
      add :updated_at, :utc_datetime, default: fragment("now()")
    end

    # fast lookup for active tokens
    create index(:refresh_tokens, [:user_id])
    create index(:refresh_tokens, [:token_hash])
  end
end
