defmodule Util do
  def convert_keys_to_atoms(data) do
    for {key, val} <- data, into: %{} do
      {String.to_existing_atom(key), val}
    end
  end

  @spec config_exists?(any()) :: :config_not_found | :exists
  def config_exists?(server_name) do
    case ConsulShim.getkv("server/config/#{server_name}.json") do
      :error ->
        :config_not_found
      %{} ->
        :exists
    end
  end
end
