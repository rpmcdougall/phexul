defmodule ServerOps do
  alias Consul.HTTP.Raw, as: ConsulRaw

  def get_server(server_name) do
    %Consul.KV{value: server_config} = Consul.KV.get("server/config/#{server_name}.json")
    server_config
  end

  def create_server(%Server{hostname: hostname} = server_config) do
    enc_config = Poison.encode!(server_config)
    ConsulRaw.kv_put("server/config/#{hostname}.json", enc_config)
    get_server(hostname)
  end

  def update_server(%Server{hostname: hostname} = updated_config) do
    ConsulRaw.kv_put("server/config/#{hostname}.json", updated_config)
    get_server(hostname)
  end

  def delete_server(server_name) do
    ConsulRaw.kv_delete("server/config/#{server_name}.json")
  end
end
