defmodule Util do
  def convert_keys_to_atoms(data) do
    for {key, val} <- data, into: %{} do
      {String.to_existing_atom(key), val}
    end
  end

  def config_exists?(server_name) do
    case ServerOps.get_server(server_name) do
      :error ->
        :config_not_found

      _ ->
        :exists
    end
  end
end
