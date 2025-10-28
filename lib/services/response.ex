defmodule LeftNoteServer.ResponseService do
  @moduledoc false
  def res_success(data) do
    res_success(200, data)
  end

  def res_success(data, meta_data) do
    res_success(200, data, meta_data)
  end

  def res_success(status, data, meta_data ) do
    %{success: true, status: status, data: data, meta_data: meta_data}
  end

  def res_internal_error() do
    res_error(500, "Internal Server Error")
  end

  def res_bad_request() do
    res_error(400, "Bad Request")
  end

  def res_unauthorized() do
    res_error(401, "Unauthorized")
  end

  def res_forbidden() do
    res_error(403, "Forbidden")
  end

  def res_not_found() do
    res_error(404, "Not Found")
  end



  def res_error(status, message) do
    %{success: false, status: status, message: message}
  end



end
