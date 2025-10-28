defmodule LeftNoteServerWeb.ResponseController do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  def res_success(conn, data) do
    conn
    |> put_status(:ok)
    |> json(%{success: true, data: data})
  end

  def res_success(conn, data, meta_data) do
    conn
    |> put_status(:ok)
    |> json(%{success: true, data: data, meta_data: meta_data})
  end

  def res_error(conn, status, message) do
    conn
    |> put_status(status)
    |> json(%{success: false, status: status, message: message})
  end
end
