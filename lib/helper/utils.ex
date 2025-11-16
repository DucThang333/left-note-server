defmodule LeftNoteServer.Helper.Utils do
  def remove_nil_from_map(map) do
    Enum.reduce(map, %{}, fn {key, value}, acc ->
      if value != nil do
        Map.put(acc, key, value)
      else
        acc
      end
    end)
  end

  def parse_map(obj) when is_atom(obj) do
    Enum.reduce(obj, %{}, fn {key, value}, acc ->
      Map.put(acc, key, value)
    end)
  end

  def parse_map(obj) do
    obj
  end

  def parse_atom(obj) when is_map(obj) do
    for {k, v} <- obj, into: %{} do
      key = if is_binary(k), do: String.to_atom(k), else: k
      {key, v}
    end
  end

  def parse_atom(obj) do
    obj
  end
end
