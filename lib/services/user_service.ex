defmodule LeftNoteServer.UserService do
  alias LeftNoteServer.{Users}
  import LeftNoteServer.ResponseService

  def get_user(id) do
    user = Users.get(id)

    case user do
      nil -> res_not_found()
      _ -> res_success(%{user: Users.render(user)})
    end
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
