defmodule LeftNoteServer.NoteFields do
  defmacro fields do
    quote do
      field :title, :string
      field :description, :string
      field :created_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :is_archived, :boolean
      belongs_to :notebooks, LeftNoteServer.Notebook, foreign_key: :notebook_id
      many_to_many :tags, LeftNoteServer.Tag, join_through: "note_tags"
    end
  end
end

defmodule LeftNoteServer.Note do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset
  import LeftNoteServer.NoteFields

  alias LeftNoteServer.{Repo, Helper}

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "notes" do
    fields()
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [
      :notebook_id,
      :title,
      :description,
      :content,
      :is_archived
    ])
    |> validate_required([:title, :notebook_id])
    |> foreign_key_constraint(:notebook_id)
  end

  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert()
  end

  def update(id, params) when is_binary(id), do: Repo.get(__MODULE__, id) |> update(params)
  def update(note, params) when is_map(note), do: note |> changeset(params) |> Repo.update()

  def delete(id) when is_binary(id), do: Repo.get(__MODULE__, id) |> delete()
  def delete(note) when is_map(note), do: note |> Repo.delete()

  def render(note, opts \\ {})
  def render(note, opts) when is_list(note), do: Enum.map(note, &render(&1, opts))
  def render(%Ecto.Association.NotLoaded{}, _opts), do: nil

  def render(note, opts) when is_struct(note),
    do: Map.from_struct(note) |> Map.drop([:__meta_data__]) |> render(opts)

  def render(note, opts) when is_map(note), do: note |> Helper.Utils.parse_atom() |> render(opts)

  def render(note, opts) do
    data = %{
      id: note[:id],
      title: note[:title],
      description: note[:description],
      created_at: note[:created_at],
      updated_at: note[:updated_at],
      is_archived: note[:is_archived],
      notebook_id: note[:notebook_id]
    }

    # add content
    data = if opts[:include_content], do: Map.put(data, :content, note[:content]), else: data

    data
  end
end

# Schema exclude content of note
defmodule LeftNoteServer.NoteHasContent do
  @moduledoc false
  use Ecto.Schema

  import LeftNoteServer.NoteFields

  alias LeftNoteServer.{Repo, Helper}

  schema "notes" do
    fields()
    field :content, :string
  end
end
