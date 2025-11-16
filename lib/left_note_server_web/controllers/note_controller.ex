defmodule LeftNoteServerWeb.NoteController do
  use LeftNoteServerWeb, :controller

  alias LeftNoteServer.NoteService

  def create(conn, params) do
    res = NoteService.create(params)

    conn
    |> put_status(res.status)
    |> json(res)
  end

  def update(conn, params) do
    res = NoteService.update(params)

    conn
    |> put_status(res.status)
    |> json(res)
  end

  def delete(conn, params) do
    res = NoteService.delete(params)

    conn
    |> put_status(res.status)
    |> json(res)
  end
end
