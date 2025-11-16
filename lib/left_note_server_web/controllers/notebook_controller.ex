defmodule LeftNoteServerWeb.NotebookController do
  use LeftNoteServerWeb, :controller

  alias LeftNoteServer.NotebookService

  def index(conn, _params) do
    res = NotebookService.get_notebooks()

    conn
    |> put_status(res.status)
    |> json(res)
  end

  def create(conn, params) do
    res = NotebookService.create(params)

    conn
    |> put_status(res.status)
    |> json(res)
  end

  def update(conn, params) do
    res = NotebookService.update(params)

    conn
    |> put_status(res.status)
    |> json(res)
  end

  def delete(conn, params) do
    res = NotebookService.delete(params)

    conn
    |> put_status(res.status)
    |> json(res)
  end
end
