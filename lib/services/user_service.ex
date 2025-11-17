defmodule LeftNoteServer.UserService do
  alias LeftNoteServer.{User}
  import LeftNoteServer.ResponseService

  def get_user(id) do
    user = User.get(id)

    case user do
      nil -> res_not_found()
      _ -> res_success(%{user: User.render(user)})
    end
  end

  def create_user(attrs) do
    User.create(attrs)
  end

  def update_user(id, attrs) do
    User.get(id)
    |> User.update(attrs)
  end

  def delete_user(id) do
    User.get(id)
    |> User.update(%{"is_removed" => true})
  end
end
