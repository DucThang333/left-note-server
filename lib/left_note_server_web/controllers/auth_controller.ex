defmodule LeftNoteServerWeb.AuthController do
  use LeftNoteServerWeb, :controller

  alias LeftNoteServer.{AuthService}
  alias LeftNoteServer.Helper.Utils

  def login(conn, params) do
    username = params["username"]
    password = params["password"]

    res =
      AuthService.login(%{
        "username" => username,
        "password" => password
      })

    conn
    |> put_status(res.status)
    |> json(res)
  end

  def register(conn, params) do
    username = params["username"]
    password = params["password"]
    email = params["email"]

    register_params =
      %{
        "username" => username,
        "password" => password,
        "email" => email
      }
      |> Utils.remove_nil_from_map()

    res = AuthService.register(register_params)

    conn
    |> put_status(res.status)
    |> json(res)
  end

  def logout(conn, params) do
    token_hash = params["refresh_token"]

    res = AuthService.logout(token_hash)

    conn
    |> put_status(res.status)
    |> json(res)
  end
end
