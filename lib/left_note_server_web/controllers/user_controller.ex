defmodule LeftNoteServerWeb.UserController do
  use LeftNoteServerWeb, :controller

  alias LeftNoteServer.{UserService}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def me(conn, _params) do
    current_user = Process.get(:current_user)

    res = UserService.get_user(current_user[:id])

    conn
    |> put_status(res.status)
    |> json(res)
  end

  def get_user(conn, %{"id" => id}) do
    res = UserService.get_user(id)

    conn
    |> put_status(res.status)
    |> json(res)
  end
end
