defmodule SpaceArena.Router do
  use SpaceArena.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    resources "/game_hosts", SpaceArena.GameHostController
  end

  scope "/", SpaceArena do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", SpaceArena do
  #   pipe_through :api
  # end
end
