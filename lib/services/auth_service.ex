defmodule LeftNoteServer.AuthService do
  alias LeftNoteServer.{Users, Repo}
  alias Bcrypt
  alias LeftNoteServer.Token

  import LeftNoteServer.ResponseService
  import Ecto.Query

  def login(%{"username" => username, "password" => password}) do
    user = Users.get(%{username: username})

    if user && Bcrypt.verify_pass(password, user.password_hash) do
      user_claims = Users.render(user)
      signer = Token.get_signer!()
      token = Token.generate_and_sign!(user_claims, signer)

      res_success(%{
        token: token
      })
    else
      res_not_found()
    end
  end

  def register(%{"username" => username, "password" => password, "email" => email}) do
    user = %{
      username: username,
      password_hash: Bcrypt.hash_pwd_salt(password),
      email: email
    }

    Repo.one(from u in Users, where: u.username == ^username or u.email == ^email)
    |> case do
      nil ->
        user_created = Users.create(user) |> Users.render()
        res_success(user_created)

      _ ->
        res_conflict()
    end
  end

  def register(_params) do
    res_bad_request()
  end
end
