defmodule LeftNoteServer.Services.UserService do
  alias LeftNoteServer.{Users}


  def get_user(id) do
    Users.get(id)
  end

  def create_user(attrs) do
    Users.create(attrs)
  end

  def update_user(id, attrs) do
    Users.get(id)
    |> Users.update(attrs)
  end

  def delete_user(id) do
    Users.get(id)
    |> Users.update(%{"is_removed" => true})
  end
end
