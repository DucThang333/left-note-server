defmodule LeftNoteServer.Users do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :created_at, :naive_datetime
    field :is_deleted, :boolean
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:username, :email, :password_hash, :created_at, :is_deleted])
    |> validate_required([:username, :email, :password_hash])
    
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    
  end

end
