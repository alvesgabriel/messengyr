defmodule MessengyrWeb.Router do
  use MessengyrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Messengyr.Auth.ApiPipeline
  end

  pipeline :browser_session do
    plug Messengyr.Auth.Pipeline
  end

  scope "/", MessengyrWeb do
    pipe_through [:browser]

    get "/", PageController, :index

    get "/signup", PageController, :signup
    post "/signup", PageController, :create_user

    get "/login", PageController, :login
    post "/login", PageController, :login_user
  end

  scope "/", MessengyrWeb do
    pipe_through [:browser, :browser_session]

    get "/logout", PageController, :logout

    get "/messages", ChatController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", MessengyrWeb do
    pipe_through :api

    resources "/users/", UserController, only: [:show]

    # Chat routes
    resources "/rooms/", RoomController
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MessengyrWeb.Telemetry
    end
  end
end
