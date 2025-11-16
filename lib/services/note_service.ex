defmodule LeftNoteServer.NoteService do
  import LeftNoteServer.ResponseService

  alias LeftNoteServer.Notes
  alias LeftNoteServer.Notebooks
  alias LeftNoteServer.Helper.Utils

  def create(params) do
    current_user = Process.get(:current_user)

    notebook_id = params["notebook_id"]

    notebook = Notebooks.get(notebook_id)

    if notebook.user_id != current_user[:id] do
      res_bad_request("You are not authorized to create a note in this notebook")
    else
      Notes.create(
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
            note: Notes.render(note)
          })

        {:error, error} ->
          res_error(error)
      end
    end
  end

  def update(params) do
    id = params["id"]

    Notes.update(id, params)
    |> case do
      {:ok, note} ->
        res_success(%{
          note: Notes.render(note)
        })

      {:error, error} ->
        res_error(error)
    end
  end

  def delete(params) do
    id = params["id"]

    Notes.delete(id)
    |> case do
      {:ok, note} ->
        res_success(%{
          note: Notes.render(note)
        })

      {:error, error} ->
        res_error(error)
    end
  end
end
