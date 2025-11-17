defmodule LeftNoteServer.Tag do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "tags" do
    field :object, :string
    field :object_id, :binary_id
    field :tag_id, :binary_id
    field :name, :string
    field :description, :string
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :is_archived, :boolean
    many_to_many :notes, LeftNoteServer.Note, join_through: "note_tags"
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [
      :object,
      :object_id,
      :tag_id,
      :name,
      :description,
      :created_at,
      :updated_at,
      :is_archived
    ])
    |> validate_required([:object, :object_id, :name])
  end
end
