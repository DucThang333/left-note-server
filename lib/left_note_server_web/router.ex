defmodule LeftNoteServerWeb.Router do
  use Phoenix.Router

  alias LeftNoteServerWeb.{
    AuthController,
    VersionController,
    UserController,
    NotebookController,
    NoteController
  }

  pipeline :api_private do
    plug :accepts, ["json"]
    plug CORSPlug
    plug LeftNoteServerWeb.Plugs.Authentication
  end

  pipeline :api_public do
    plug :accepts, ["json"]
    plug CORSPlug
  end

  scope "/api" do
    pipe_through :api_private

    get("/version", VersionController, :index)
  end

  scope "/api/v1" do
    pipe_through :api_public

    scope "/auth" do
      post("/login", AuthController, :login)
      post("/register", AuthController, :register)
      post("/logout", AuthController, :logout)
    end
  end

  scope "/api/v1" do
    pipe_through :api_private

    scope "/user" do
      resources "/", UserController, only: [:index]
      get("/me", UserController, :me)
      get("/:id", UserController, :get_user)
    end

    scope "/notebook" do
      resources "/", NotebookController, only: [:index, :create, :update, :delete]
    end

    scope "/note" do
      resources "/", NoteController, only: [:create, :update, :delete]
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:left_note_server, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: LeftNoteServerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
