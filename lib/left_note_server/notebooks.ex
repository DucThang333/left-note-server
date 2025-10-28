defmodule LeftNoteServer.Notebooks do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "notebooks" do
    field :user_id, :binary_id
    field :notebook_id, :binary_id
    field :title, :string
    field :description, :string
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
    has_many :notes, LeftNoteServer.Notes, foreign_key: :notebook_id
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:user_id, :notebook_id, :title, :description, :created_at, :updated_at])
    |> validate_required([:title])
    
    
    
  end

end
