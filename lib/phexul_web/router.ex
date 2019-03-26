defmodule PhexulWeb.Router do
  use PhexulWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    get "/config/:server_name", PhexulWeb.ServerConfigController, :get_server_config
    post "/config", PhexulWeb.ServerConfigController, :create_server_config
    put "/config/:server_name", PhexulWeb.ServerConfigController, :update_server_config
    delete "/config/:server_name", PhexulWeb.ServerConfigController, :delete_server_config
  end
end
