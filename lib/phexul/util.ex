defmodule Util do
  def convert_keys_to_atoms(data) do
    for {key, val} <- data, into: %{} do
      {String.to_existing_atom(key), val}
    end
  end
end
