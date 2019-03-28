defmodule PhexulWeb.ServerConfigController do
  use PhexulWeb, :controller

  def get_server_config(conn, %{"server_name" => server_name}) do
    case server_config = ServerOps.get_server(server_name) do
      :error ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Config not found."})

      _ ->
        json(conn, server_config)
    end
  end

  def create_server_config(conn, params) do
    config_with_atom_keys = Util.convert_keys_to_atoms(params)
    server_config = struct(Server, config_with_atom_keys)

    json(conn, ServerOps.create_server(server_config))
  end

  def update_server_config(%{body_params: body} = conn, %{"server_name" => server_name}) do
    case Util.config_exists?(server_name) do
      :config_not_found ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Config not found."})

      :exists ->
        :ok
    end

    json(conn, ServerOps.update_server(server_name, Poison.encode!(body)))
  end

  def delete_server_config(conn, %{"server_name" => server_name}) do
    case Util.config_exists?(server_name) do
      :config_not_found ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Config not found."})

      :exists ->
        :ok
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
        |> json(%{error: "Could not delete due to internal server issue."})
    end
  end
end
