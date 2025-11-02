defmodule LeftNoteServer.ResponseService do

  def res_success(data , meta_data \\ %{}, status \\ 200) do
    %{success: true, status: status, data: data, meta_data: meta_data}
  end

  def res_internal_error(message \\ "Internal Server Error") do
    res_error(500, message)
  end

  def res_bad_request(message \\ "Bad Request") do
    res_error(400, message)
  end

  def res_unauthorized(message \\ "Unauthorized") do
    res_error(401, message)
  end

  def res_forbidden(message \\ "Forbidden") do
    res_error(403, message)
  end

  def res_not_found(message \\ "Not Found") do
    res_error(404, message)
  end

  def res_conflict(message \\ "Conflict") do
    res_error(409, message)
  end



  @spec res_error(any()) :: %{message: any(), status: any(), success: false}
  def res_error(status \\ 500, message \\ "Internal Server Error") do
    %{success: false, status: status, message: message}
  end



end
