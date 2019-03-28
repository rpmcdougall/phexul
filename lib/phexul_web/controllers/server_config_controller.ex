defmodule PhexulWeb.ServerConfigController do
  use PhexulWeb, :controller

  def watch_helper(conn, params) do
    json(conn, %{check: "success"})
  end

  def get_server_config(conn, %{"server_name" => server_name}) do
    json(conn, ServerOps.get_server(server_name))
  end

  def create_server_config(conn, params) do
    config_with_atom_keys = Util.convert_keys_to_atoms(params)
    server_config = struct(Server, config_with_atom_keys)

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
        |> json(%{error: "Config not found"})

      _ ->
        :ok
    end

    status = ServerOps.delete_server(server_name)

    case status do
      :ok ->
        send_resp(conn, :no_content, "")

      :error ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Could not delete due to internal server issue."})
    end
  end
end
