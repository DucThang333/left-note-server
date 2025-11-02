defmodule LeftNoteServer.Repo do
  use Ecto.Repo,
    otp_app: :left_note_server,
    adapter: Ecto.Adapters.Postgres
end
