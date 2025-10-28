defmodule Mix.Tasks.Dev do
  use Mix.Task

  @shortdoc "Run Phoenix server with development env vars"

  def run(_) do
    System.put_env(%{
      "DB_USER" => "admin",
      "DB_PASSWORD" => "thang2001",
      "DB_HOST" => "localhost",
      "DB_NAME" => "left_note",
      "DB_PORT" => "5431",
      "PORT" => "4005"
    })
    Mix.shell().cmd("mix phx.server", env: System.get_env())
  end
end
