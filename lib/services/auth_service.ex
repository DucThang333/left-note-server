defmodule LeftNoteServer.AuthService do
  alias LeftNoteServer.{User, Repo, RefreshToken}
  alias Bcrypt
  alias LeftNoteServer.Token

  import LeftNoteServer.ResponseService
  import Ecto.Query

  def login(%{"username" => username, "password" => password}) do
    user = User.get_by(%{username: username})

    Repo.transaction(fn ->
      if user && Bcrypt.verify_pass(password, user.password_hash) do
        user_claims = User.render(user)
        signer = Token.signer()
        token = Token.generate_and_sign!(user_claims, signer)
        refresh_token = :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)

        # revoke old refresh token
        RefreshToken.bulk_update([user_id: user.id], revoked: true)

        RefreshToken.create(%{
          user_id: user.id,
          token_hash: refresh_token,
          # expires after 30 days
          expires_at: DateTime.add(DateTime.utc_now(), 30, :day)
        })

        res_success(%{
          token: token,
          user: user_claims,
          refresh_token: refresh_token
        })
      else
        res_not_found()
      end
    end)
    |> case do
      {:ok, res} ->
        res

      {:error, error} ->
        res_error(error)
    end
  end

  def register(%{"username" => username, "password" => password, "email" => email}) do
    user = %{
      username: username,
      password_hash: Bcrypt.hash_pwd_salt(password),
      email: email
    }

    Repo.one(from u in User, where: u.username == ^username or u.email == ^email)
    |> case do
      nil ->
        user_created = User.create(user) |> User.render()
        res_success(user_created)

      _ ->
        res_conflict()
    end
  end

  def register(_params) do
    res_bad_request()
  end

  def logout(token_hash) do
    RefreshToken.get_by(%{token_hash: token_hash})
    |> case do
      nil ->
        res_not_found()

      refresh_token ->
        RefreshToken.update(refresh_token, %{revoked: true})
        res_success("Logout successfully")
    end
  end
end
