defmodule LeftNoteServer.Notebooks do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias LeftNoteServer.{Repo, Notes, Users, Helper}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "notebooks" do
    field :title, :string
    field :description, :string
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :is_archived, :boolean, default: false

    # Self-referencing fields
    belongs_to :parent_notebook, __MODULE__, foreign_key: :notebook_id
    has_many :child_notebooks, __MODULE__, foreign_key: :notebook_id
    has_many :notes, Notes, foreign_key: :notebook_id
    belongs_to :user, Users, foreign_key: :user_id
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [
      :user_id,
      :notebook_id,
      :title,
      :description,
      :created_at,
      :updated_at,
      :is_archived
    ])
    |> validate_required([:title, :user_id])
    |> foreign_key_constraint(:user_id)
  end

  def bulk_update(query, attrs) do
    Repo.update_all(query, set: attrs)
  end

  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> put_change(:created_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> put_change(:updated_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> Repo.insert()
  end

  def all(query) do
    Repo.all(query)
  end

  def render(notebooks, opts \\ [])
  def render(notebooks, opts) when is_list(notebooks), do: Enum.map(notebooks, &render(&1, opts))
  def render(%{__cardinality__: _}, _opts), do: nil
  def render(notebook, opts) when is_struct(notebook), do: render(notebook, opts)

  def render(notebook, opts) when is_map(notebook),
    do: notebook |> Helper.Utils.parse_atom() |> render(opts)

  def render(notebook, opts) do
    data = %{
      id: notebook[:id],
      user_id: notebook[:user_id],
      notebook_id: notebook[:notebook_id],
      title: notebook[:title],
      description: notebook[:description],
      created_at: notebook[:created_at],
      updated_at: notebook[:updated_at],
      is_archived: notebook[:is_archived]
    }

    # add note
    data =
      if opts[:include_notes],
        do: Map.put(data, :notes, Notes.render(notebook[:notes] )),
        else: data

    data
  end

  def get(id) do
    Repo.get(__MODULE__, id)
  end

  def update(notebook, params) do
    notebook
    |> changeset(params)
    |> Repo.update()
  end

  def preload(notebooks, opts \\ []) do
    data = notebooks

    # load note
    data =
      if opts[:include_notes] && Ecto.assoc_loaded?(data[:notes]),
        do: Repo.preload(data, :notes),
        else: data

    data
  end
end
