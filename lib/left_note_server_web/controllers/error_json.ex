defmodule LeftNoteServerWeb.ErrorJSON do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on JSON requests.

  See config/config.exs.
  """

  # If you want to customize a particular status code,
  # you may add your own clauses, such as:

  def render("400.json", _assigns) do
    %{errors: %{detail: "Bad Request"}}
  end

  def render("401.json", _assigns) do
    %{errors: %{detail: "Unauthorized"}}
  end

  def render("403.json", _assigns) do
    %{errors: %{detail: "Forbidden"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Not Found"}}
  end

  def render("422.json", _assigns) do
    %{errors: %{detail: "Unprocessable Entity"}}
  end

  def render("429.json", _assigns) do
    %{errors: %{detail: "Too Many Requests"}}
  end

  def render("503.json", _assigns) do
    %{errors: %{detail: "Service Unavailable"}}
  end

  def render("504.json", _assigns) do
    %{errors: %{detail: "Gateway Timeout"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal Server Error"}}
  end

  def render("502.json", _assigns) do
    %{errors: %{detail: "Bad Gateway"}}
  end

end
