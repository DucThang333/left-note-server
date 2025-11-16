defmodule LeftNoteServer.RefreshToken do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias LeftNoteServer.Repo

  @primary_key {:id, :binary_id, autogenerate: true}

  @foreign_key_type :binary_id

  schema "refresh_tokens" do
    field :user_id, :binary_id
    field :token_hash, :string
    field :expires_at, :naive_datetime
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :revoked, :boolean, default: false
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [
      :user_id,
      :token_hash,
      :expires_at,
      :created_at,
      :updated_at,
      :revoked
    ])
    |> validate_required([:user_id, :token_hash, :expires_at])
    |> unique_constraint(:token_hash, name: :refresh_tokens_user_id_token_hash_index)
  end

  def get_by(params) do
    Repo.get_by(__MODULE__, params)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!()
  end

  def get_by_user_id(user_id) do
    Repo.get_by(__MODULE__, user_id: user_id)
  end

  def delete(refresh_token) do
    Repo.delete(refresh_token)
  end

  def update(refresh_token, attrs) do
    refresh_token
    |> changeset(attrs)
    |> Repo.update()
  end

  def bulk_update(conditions, attrs) do
    Enum.reduce(conditions, __MODULE__, fn {key, val}, query ->
      from(r in query, where: field(r, ^key) == ^val)
    end)
    |> Repo.update_all(set: attrs)
  end
end
