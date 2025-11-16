defmodule LeftNoteServer.Repo do
  use Ecto.Repo,
    otp_app: :left_note_server,
    adapter: Ecto.Adapters.Postgres

  def start(_type, _args) do
    children = [
      __MODULE__
      # other processes...
    ]

    opts = [strategy: :one_for_one, name: LeftNoteServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
