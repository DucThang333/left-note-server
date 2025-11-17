defmodule LeftNoteServer.NoteTag do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "note_tags" do
    belongs_to :notes, LeftNoteServer.Note, foreign_key: :note_id
    belongs_to :tags, LeftNoteServer.Tag, foreign_key: :tag_id
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:note_id, :tag_id])
    |> validate_required([:note_id, :tag_id])
    |> foreign_key_constraint(:note_id)
    |> foreign_key_constraint(:tag_id)
  end
end
