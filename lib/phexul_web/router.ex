defmodule PhexulWeb.Router do
  use PhexulWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhexulWeb do
    pipe_through :api
  end
end
