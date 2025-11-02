defmodule LeftNoteServerWeb.Plugs.Authentication do
  use LeftNoteServerWeb, :controller

  import Plug.Conn
  import LeftNoteServer.Token

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case verify_and_validate(token) do
          {:ok, user_claims} ->
            conn |> assign(:current_user, user_claims)

          {:error, _} ->
            conn |> put_status(401) |> json(%{message: "Unauthorized"}) |> halt()
        end

      _ ->
        conn |> put_status(401) |> json(%{message: "Unauthorized"}) |> halt()
    end
  end
end
