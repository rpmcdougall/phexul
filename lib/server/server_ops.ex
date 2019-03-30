defmodule ServerOps do

  @consul_shim Application.get_env(:phexul, :consul_shim)
  def get_server(server_name) do
    case config = @consul_shim.getkv("server/config/#{server_name}.json") do
      :error ->
        :config_not_found
      %{} ->
        config
    end
  end


  def create_server(%Server{hostname: hostname} = server_config) do
    case @consul_shim.createkv("server/config/#{hostname}.json", server_config) do
      :exists ->
        :exists
      :ok ->
        get_server(hostname)
    end
  end

  def update_server(hostname, config) do
    case @consul_shim.updatekv("server/config/#{hostname}.json", config) do
      :config_not_found ->
        :config_not_found
       :ok ->
        get_server(hostname)
    end
  end

  def delete_server(server_name) do
    case @consul_shim.deletekv("server/config/#{server_name}.json") do
      :ok -> :ok
      :error -> :error
    end
  end
end
