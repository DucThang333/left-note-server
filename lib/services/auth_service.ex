defmodule LeftNoteServer.Services.AuthService do
  alias LeftNoteServer.{Repo, User}
  import LeftNoteServer.ResponseService

  def login(user_name, password) do
    user = Repo.get_by(User, user_name: user_name)
    if user do
      res_success(user)
    else
      res_not_found()
    end
  end

end
