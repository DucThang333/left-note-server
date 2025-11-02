defmodule LeftNoteServerWeb.UserController do
  use LeftNoteServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
