defmodule LeftNoteServerWeb.Plugs.Authentication do
  use LeftNoteServerWeb, :controller

  import Plug.Conn
  import LeftNoteServer.Token

  alias LeftNoteServer.{ResponseService, Helper}

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case verify_and_validate(token, verifier()) do
          {:ok, user_claims} ->
            Process.put(:current_user, Helper.Utils.parse_atom(user_claims))
            conn

          {:error, error} ->
            res =
              case error.claim do
                "exp" -> ResponseService.res_bad_request("Token expired")
                _ -> ResponseService.res_internal_error("Invalid token")
              end

            conn |> put_status(401) |> json(res) |> halt()
        end

      _ ->
        conn
        |> put_status(401)
        |> json(ResponseService.res_not_found("Token not found"))
        |> halt()
    end
  end
end
