defmodule LeftNoteServer.Notes do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "notes" do
    field :title, :string
    field :description, :string
    # JSONB field - requires manual type specification based on your data:
# field :content, :map                    # For JSON objects: {"key": "value"}
# field :content, {:array, :string}       # For string arrays: ["value1", "value2"]
# field :content, {:array, :integer}      # For integer arrays: [1, 2, 3]
# field :content, {:array, :map}          # For object arrays: [{"id": 1}, {"id": 2}]

    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :is_archived, :boolean
    belongs_to :notebooks, LeftNoteServer.Notebooks, foreign_key: :notebook_id
    many_to_many :tags, LeftNoteServer.Tags, join_through: "note_tags"
  end

  
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:notebook_id, :title, :description, :content, :created_at, :updated_at, :is_archived])
    
    
    
    |> foreign_key_constraint(:notebook_id)
  end

end
