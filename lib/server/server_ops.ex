defmodule ServerOps do
  alias Consul.HTTP.Raw, as: ConsulRaw

  def get_server(server_name) do
    try do
      %Consul.KV{value: server_config} = Consul.KV.get("server/config/#{server_name}.json")
      server_config
    rescue
      ArgumentError -> :error
    end
  end

  def create_server(%Server{hostname: hostname} = server_config) do
    enc_config = Poison.encode!(server_config)
    ConsulRaw.kv_put("server/config/#{hostname}.json", enc_config)
    get_server(hostname)
  end

  def update_server(hostname, config) do
    ConsulRaw.kv_put("server/config/#{hostname}.json", config)
    get_server(hostname)
  end

  def delete_server(server_name) do
    %HTTPoison.Response{status_code: status} =
      ConsulRaw.kv_delete("server/config/#{server_name}.json")

    case status do
      200 -> :ok
      _ -> :error
    end
  end
end
