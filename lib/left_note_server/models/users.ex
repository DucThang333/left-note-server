defmodule LeftNoteServer.Users do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias LeftNoteServer.{Repo}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :created_at, :naive_datetime
    field :is_deleted, :boolean, default: false
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:username, :email, :password_hash, :created_at, :is_deleted])
    |> validate_required([:username, :email, :password_hash])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def get_all!() do
    Repo.all(__MODULE__)
  end

  def get(params) do
    Repo.get_by(__MODULE__, params)
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert!()
  end

  def update(user, attrs) do
    user
    |> changeset(attrs)
    |> Repo.update!()
  end

  def delete(user) do
    Repo.delete(user)
  end

  def render(user) do
    render(user, %{})
  end

  def render(user, %{includes: includes}) when is_list(includes) and length(includes) > 0 do
    Enum.reduce(includes, %{}, fn key, acc ->
      Map.put(acc, key, render(user, key))
    end)
  end

  def render(user, %{excludes: excludes}) when is_list(excludes) and length(excludes) > 0 do
    Enum.reduce(excludes, user, fn key, acc ->
      Map.delete(acc, key)
    end)
  end

  def render(user, opt) when is_map(opt) do
    result = %{
      id: user.id,
      username: user.username,
      email: user.email,
      created_at: user.created_at,
      is_deleted: user.is_deleted
    }

    result =
      if Map.has_key?(opt, :includes) do
        render(user, %{includes: opt[:includes]})
      else
        result
      end

    if Map.has_key?(opt, :excludes) do
      render(user, %{excludes: opt[:excludes]})
    else
      result
    end
  end

  def is_valid_params(params) when is_map(params) do
    Enum.reduce(params, true, fn key, acc ->
      acc and is_valid_params(key)
    end)
  end

  def is_valid_params(%{"username" => username}) do
    username |> String.length() >= 3 and String.length(username) <= 20
  end

  def is_valid_params(%{"email" => email}) do
    email |> String.length() >= 3 and String.length(email) <= 20
  end

  def is_valid_params(%{"password" => password}) do
    password |> String.length() >= 3 and String.length(password) <= 20
  end
end
