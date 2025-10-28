defmodule LeftNoteServer.SchemaMigrations do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "schema_migrations" do
    field :version, :integer
    field :inserted_at, :naive_datetime
  end


  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:version, :inserted_at])
    |> validate_required([:version])



  end

end
