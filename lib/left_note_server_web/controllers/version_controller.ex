defmodule LeftNoteServerWeb.VersionController do
  use LeftNoteServerWeb, :controller

  def index(conn, _params) do
    version = File.read!("version.txt")
    json conn, %{version: version}
  end
end
