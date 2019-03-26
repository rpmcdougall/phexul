defmodule PhexulWeb.ServerConfigController do
  use PhexulWeb, :controller

  def get_server_config(conn, %{"server_name" => server_name}) do
    json(conn, ServerOps.get_server(server_name))
  end

  def create_server_config(conn, params) do
    server_config =
      %Server{}
      |> Map.merge(params)

    json(conn, ServerOps.create_server(server_config))
  end

  def update_server_config(conn, %{"server_name" => server_name}) do
    %{body_params: body} = conn
    json(conn, ServerOps.update_server(server_name, Poison.encode!(body)))
  end

  def delete_server_config(conn, %{"server_name" => server_name}) do
    case ServerOps.get_server(server_name) do
      :error ->
        conn
        |> put_status(:not_found)
        |> json(%{status: "Config not found"})
    end

    status = ServerOps.delete_server(server_name)

    case status do
      :ok ->
        conn
        |> put_status(:no_content)
        |> json("")

      :error ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Could not delete config."})
    end
  end
end
