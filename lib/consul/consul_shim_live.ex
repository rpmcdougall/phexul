defmodule ConsulShim.Live do
  alias Consul.HTTP.Raw, as: ConsulRaw

  def getkv(key) do
    try do
      %Consul.KV{value: kv} = Consul.KV.get(key)
      kv
    rescue
      ArgumentError -> :error
    end
  end

  def deletekv(key) do
    %HTTPoison.Response{status_code: status} = ConsulRaw.kv_delete(key)

    case status do
      200 ->
        :ok

      _ ->
        :error
    end
  end

  def updatekv(key, %Server{hostname: hostname} = data) do
    enc_config = Poison.encode!(data)

    case Util.config_exists?(hostname) do
      :exists ->
        ConsulRaw.kv_put(key, enc_config)
        :ok

      :config_not_found ->
        :config_not_found
    end
  end

  def createkv(key, %Server{hostname: hostname} = data) do
    enc_config = Poison.encode!(data)

    case Util.config_exists?(hostname) do
      :exists ->
        :exists

      :config_not_found ->
        ConsulRaw.kv_put(key, enc_config)
        :ok
    end
  end
end
