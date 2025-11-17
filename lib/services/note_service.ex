defmodule LeftNoteServer.NoteService do
  import LeftNoteServer.ResponseService

  alias LeftNoteServer.Note
  alias LeftNoteServer.Notebook
  alias LeftNoteServer.Helper.Utils

  def create(params) do
    current_user = Process.get(:current_user)

    notebook_id = params["notebook_id"]

    notebook = Notebook.get(notebook_id)

    if notebook.user_id != current_user[:id] do
      res_bad_request("You are not authorized to create a note in this notebook")
    else
      Note.create(
        %{
          "notebook_id" => notebook_id,
          "title" => params["title"],
          "description" => params["description"],
          "content" => params["content"]
        }
        |> Utils.remove_nil_from_map()
      )
      |> case do
        {:ok, note} ->
          res_success(%{
            note: Note.render(note)
          })

        {:error, error} ->
          res_error(error)
      end
    end
  end

  def update(params) do
    id = params["id"]

    Note.update(id, params)
    |> case do
      {:ok, note} ->
        res_success(%{
          note: Note.render(note)
        })

      {:error, error} ->
        res_error(error)
    end
  end

  def delete(params) do
    id = params["id"]

    Note.delete(id)
    |> case do
      {:ok, note} ->
        res_success(%{
          note: Note.render(note)
        })

      {:error, error} ->
        res_error(error)
    end
  end
end
