defmodule LeftNoteServer.NotebookService do
  alias LeftNoteServer.{Notebook}

  import LeftNoteServer.ResponseService
  import Ecto.Query

  def get_notebooks() do
    current_user = Process.get(:current_user)

    query = from n in Notebook, where: n.user_id == ^current_user[:id] and n.is_archived == false

    notebooks = Notebook.all(query) |> renderDefault()

    res_success(%{
      notebooks: notebooks
    })
  end

  def create(params) do
    current_user = Process.get(:current_user)

    params = Map.put(params, "user_id", current_user[:id])

    Notebook.create(params)
    |> case do
      {:ok, notebook} ->
        notebook = notebook |> renderDefault()

        res_success(%{
          notebook: notebook
        })

      {:error, error} ->
        res_error(error)
    end
  end

  def update(params) do
    id = params["id"]

    Notebook.get(id)
    |> case do
      nil ->
        res_not_found()

      notebook ->
        Notebook.update(notebook, params)
        |> case do
          {:ok, notebook} ->
            notebook = notebook |> renderDefault()

            res_success(%{
              notebook: notebook
            })

          {:error, error} ->
            res_error(error)
        end
    end
  end

  def delete(params) do
    id = params["id"]

    notebooks = get_all_notebooks(id)

    query = from n in Notebook, where: n.id in ^Enum.map(notebooks, & &1.id)

    Notebook.bulk_update(query, is_archived: true)
    |> case do
      {count, _} ->
        res_success(%{
          count: count,
          notebook_ids: Enum.map(notebooks, & &1.id)
        })

      _ ->
        res_error()
    end
  end

  defp get_all_notebooks(root) when is_binary(root) do
    Notebook.get(root)
    |> case do
      nil ->
        res_not_found()

      notebook ->
        get_all_notebooks(notebook)
    end
  end

  defp get_all_notebooks(root) do
    query = from n in Notebook, where: n.notebook_id == ^root.id

    notebooks = Notebook.all(query) |> Enum.flat_map(&get_all_notebooks/1)

    [root | notebooks]
  end

  defp renderDefault(notebooks) when is_list(notebooks), do: Enum.map(notebooks, &renderDefault/1)

  defp renderDefault(notebook) do
    notebook |> Notebook.preload(%{include_notes: true}) |> Notebook.render(include_notes: true)
  end
end
