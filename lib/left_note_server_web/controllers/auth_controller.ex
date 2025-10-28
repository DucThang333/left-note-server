defmodule LeftNoteServerWeb.AuthController do
  use LeftNoteServerWeb, :controller

  # alias LeftNoteServer.{AuthService}

  import LeftNoteServerWeb.ResponseController


  def login(conn, params) do
    user_name = params["user_name"]
    password = params["password"]

    user = AuthService.login(user_name, password)

    res_success(conn, user)

  end


end
